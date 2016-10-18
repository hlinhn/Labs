let range lower upper =
  let rec range_c lower upper =
    if lower > upper then []
    else lower :: (range_c (lower + 1) upper) in
  range_c lower upper

let row_to_col lst =
  List.map (fun e -> List.map (fun x -> List.nth x e) lst) (range 0 ((List.length lst) - 1))
           
(*row based*)  
let rotate lst num =
  let displ = num mod (List.length lst) in
  let rec aux lst num rest =
    if (num == 0) then (lst @ rest) else
      aux (List.tl lst) (num - 1) (List.rev ((List.hd lst) :: (List.rev rest))) in
  aux lst displ []
  
let xor_multi src1 src2 =
  List.map2 (fun e e' -> e lxor e') src1 src2
            
let sub_multi src1 src2 =
  List.map (fun x -> List.nth src2 x) src1
  
(*substitute bytes*)
let sub_bytes src box =
  List.map (fun x -> (List.map (fun e -> (List.nth box e))) x) src

let rec mult vector num =
  if num == 1 then vector else
    if num == 2 then let shifted = (vector lsl 1) land 255 in
                     if (vector lsr 7) == 1 then (shifted lxor 27) else shifted
    else
      let k = num / 2 in 
      if num mod 2 == 1 then (mult vector (num - 1)) lxor vector
      else mult (mult vector k) 2
  
(*add round key*)
let add_round src sub =
  List.map2 (fun x y -> (List.map2 (fun e e' -> (e lxor e')) x y)) sub src

let round_const =
  let rec rcon = function
    | 0 -> 141
    | 1 -> 1
    | _ as j -> mult (rcon (j - 1)) 2 in
  List.map (fun x -> rcon x) (range 0 10)

let sbox =
  let rec mul3 = function
    | 0 -> 0
    | 1 -> 3
    | _ as k -> mult (mul3 (k - 1)) 3 in
  let rlut = List.map (fun x -> mul3 x) (range 0 255) in
  let rlut_ind = List.combine rlut (range 0 255) in
  let sorted = List.sort (fun x y -> compare (fst x) (fst y)) rlut_ind in
  let rec ror torot = function
    | 0 -> torot
    | _ as num -> ror (((torot lsl 1) lor (torot lsr 7)) land 255) (num - 1) in
  let trans num = List.fold_left (fun x y -> x lxor y) 0
                                 (List.map (fun e -> ror num e) (range 0 4)) in
  let opposite = function
    | 0 -> 0
    | 1 -> 1
    | _ as num -> List.nth rlut (255 - (snd (List.nth sorted num))) in
  List.map (fun x -> 99 lxor (trans (opposite x))) (range 0 255)  

let rsbox =
  let lut = List.combine sbox (range 0 255) in
  let sorted = List.sort (fun x y -> compare (fst x) (fst y)) lut in
  snd (List.split sorted)
      
(*shift rows, assume input is good. Can make a different function to test if input conforms to standard to use in other place too*)
let shift_rows src =
  let height = List.length src in
  let rtc = row_to_col src in
  let roted = List.map (fun x -> rotate (List.nth rtc x) x) (range 0 (height - 1)) in
  row_to_col roted
             
let rshift_rows src =
  let rtc = row_to_col src in
  let roted = List.map (fun x -> rotate (List.nth rtc x) (4 - x)) (range 0 ((List.length src) - 1)) in
  row_to_col roted
             
(*mix columns, row based, input column*)
let mix_col src enc =
  let mat =
    if enc then [[2;3;1;1];[1;2;3;1];[1;1;2;3];[3;1;1;2]]
    else [[14;11;13;9];[9;14;11;13];[13;9;14;11];[11;13;9;14]] in
  let multiplication vector mat =
    List.fold_left (fun e e' -> e lxor e') 0 (List.map2 (fun x y -> mult x y) vector mat) in
  List.map (fun x -> multiplication x src) mat
  
let mix_cols src enc =
  List.map (fun x -> mix_col x enc) src

let transform col box const =
  let rot = rotate (sub_multi col box) 1 in
  ((List.hd rot) lxor const) :: (List.tl rot)

(*key expansion, column based*)
let expand_key key =
  let rec round prev i =
    if i == 0 then prev
    else
      let rec next_col pcols j =
        if j == 0 then
          xor_multi (transform (List.nth pcols 3) sbox (List.nth round_const i)) (List.nth pcols 0)
        else
          xor_multi (List.nth pcols j) (next_col pcols (j - 1)) in
      let cal = round prev (i - 1) in
      List.map (fun x -> next_col cal x) (range 0 3) in 
  List.map (fun x -> round key x) (range 0 10)
           
let encrypt mes key =
  let keys = expand_key key in
  let driver_round mes key num =
    let rec rounds mes keys prevs state num =
      if state == num then List.hd prevs
      else
        let new_prev =
          add_round (mix_cols (shift_rows (sub_bytes (List.hd prevs) sbox)) true)
                    (List.hd keys) in
        rounds mes (List.tl keys) (new_prev :: prevs) (state + 1) num in
    rounds mes (List.tl keys) [(add_round mes (List.hd keys))] 0 num in
  add_round (shift_rows (sub_bytes (driver_round mes key 9) sbox)) (List.hd (List.rev keys))

let decrypt mes key =
  let keys = List.rev (expand_key key) in
  let driver_round mes key num =
    let rec rounds mes keys prevs state num =
      if state == num then List.hd prevs
      else
        let new_prev =
          sub_bytes (rshift_rows (mix_cols (add_round (List.hd prevs) (List.hd keys)) false)) rsbox in
        rounds mes (List.tl keys) (new_prev :: prevs) (state + 1) num in
    rounds mes (List.tl keys) [(sub_bytes (rshift_rows (add_round mes (List.hd keys))) rsbox)] 0 num in
  add_round (driver_round mes key 9) (List.hd (List.rev keys))
                     
            
let convert_string inout =
  let split = List.map (fun e -> List.map (fun e' -> String.sub e e' ((String.length e) / 4))
                                          [0;2;4;6])
                       (List.map (fun x -> String.sub inout x ((String.length inout) / 4))
                                 [0;8;16;24]) in
  List.map (fun e -> List.map (fun e' -> Scanf.sscanf e' "%x" (fun x -> x)) e) split
let convert_to_string out =
  String.concat "" (List.map (fun e -> Printf.sprintf "%X" e) (List.flatten out))
           
                                                                             
