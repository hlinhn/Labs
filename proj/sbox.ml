(*normal base, trace 1; 
  for GF(256) the base is [0xFE,0xFF]
  for GF(16) the base is [0x5D,0x5C]
  for GF(4) the base is [0xBC,0xBD]
 *)

(*swap, same as square*)
let invert2 num =
  let upper = (num land 2) lsr 1 in
  let lower = num land 1 in
  (lower lsl 1) lor (upper land 1)

let add4 num1 num2 =
  num1 lxor num2
              
let add2 num1 num2 =
  num1 lxor num2
              
let scaleN num =
  let upper = (num land 2) lsr 1 in
  let lower = num land 1 in
  let modupper = lower in
  let modlower = upper lxor lower in
  (modupper lsl 1) lor (modlower land 1)             
                    
let mul2 num1 num2 =
  let up1 = (num1 land 2) lsr 1 in
  let up2 = (num2 land 2) lsr 1 in
  let low1 = num1 land 1 in
  let low2 = num2 land 1 in
  let theta = (up1 lxor low1) land (up2 lxor low2) in
  let theta1 = (up1 land up2) lxor theta in
  let theta2 = (low1 land low2) lxor theta in
  (theta1 lsl 1) lor (theta2 land 1)
                       
let scale2 num = 
  let upper = num lsr 1 in
  let lower = num land 1 in
  let modupper = upper lxor lower in
  let modlower = upper in
  (modupper lsl 1) lor (modlower land 1)
                         
let scasq4 num =
  let upper = num lsr 2 in
  let lower = num land 3 in
  let modupper = invert2 (add2 upper lower) in
  let modlower = scale2 (invert2 lower) in
  (modupper lsl 2) lor (modlower land 3)                         
                         
let mul4 num1 num2 =
  let up1 = num1 lsr 2 in
  let up2 = num2 lsr 2 in
  let low1 = num1 land 3 in
  let low2 = num2 land 3 in
  let theta = scaleN (mul2 (add2 up1 low1) (add2 up2 low2)) in
  let theta1 = add2 (mul2 up1 up2) theta in
  let theta2 = add2 (mul2 low1 low2) theta in
  (theta1 lsl 2) lor (theta2 land 3)
                       
let invert4 num =
  let upper = num lsr 2 in
  let lower = num land 3 in
  let theta = add2 (mul2 upper lower) (scaleN (invert2 (add2 upper lower))) in
  let invtheta = invert2 theta in
  let modupper = mul2 invtheta lower in
  let modlower = mul2 invtheta upper in
  (modupper lsl 2) lor (modlower land 3)
                   
  
let invert8 num =
  let upper = num lsr 4 in
  let lower = num land 15 in
  let theta = add4 (mul4 upper lower) (scasq4 (add4 upper lower)) in
  let invtheta = invert4 theta in
  let modupper = mul4 invtheta lower in
  let modlower = mul4 invtheta upper in
  (modupper lsl 4) lor (modlower land 15)

let convert_to_bits num =
  let rec convert num lst = function
    | 0 -> num :: lst
    | _ as k -> convert (num lsr 1) ((num land 1) :: lst) (k - 1) in
  convert num [] 7

let convert_to_num bits =
  List.fold_left (fun x y -> x lor y) 0 (List.rev (List.mapi (fun n e -> e lsl n) (List.rev bits)))
         
let mul_bit num1 num2 =
  List.fold_left (fun x y -> x lxor y) 0 (List.map2 (fun x y -> x land y) (convert_to_bits num1) (convert_to_bits num2))
                         
let matrix_mul num mat =
  convert_to_num (List.map (fun x -> mul_bit num x) mat)
                         
let change_basis num dir =
  let forward = [18;235;237;66;126;178;34;4] in
  let backward = [231; 113; 99; 225; 155; 1; 97; 79] in
  let to_mul = if dir then forward else backward in
  matrix_mul num to_mul

let affine_trans num dir =
  let forward = [40; 136; 65; 168; 248; 109; 50; 82] in
  let backward = [144; 83; 80; 75; 208; 164; 25; 115] in
  let to_mul = if dir then forward else backward in
  matrix_mul num to_mul

let forwrbox num =
  (affine_trans (invert8 (change_basis num false)) true) lxor 99

let test_change num =
  List.fold_left (fun x y -> x lxor y) 0 (List.map2 (fun x y -> if x == 1 then y else 0) (convert_to_bits num) [88; 45; 158; 11; 220; 4; 3; 36])
                 
(*change basis forward*)
let test_change2 num =
  List.fold_left (fun x y -> x lxor y) 0 (List.map2 (fun x y -> if x == 1 then y else 0) (convert_to_bits num) [152; 243; 242; 72; 9; 129; 169; 255])

let reverse_base num =
  List.fold_left (fun x y -> x lxor y) 0 (List.map2 (fun x y -> if x == 1 then y else 0) (convert_to_bits num) [100; 120; 110; 140; 104; 41; 222; 96])

let reverse_trans num =
   List.fold_left (fun x y -> x lxor y) 0 (List.map2 (fun x y -> if x == 1 then y else 0) (convert_to_bits num) [140; 121; 5; 235; 18; 4; 81; 83])
