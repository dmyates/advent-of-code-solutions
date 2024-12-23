NB. Expand to disk map
expand =: 3 : 0
    fileID =. 0
    disk =. 0 $ a: NB. empty array
    for_size. y do.
        if. 2 | size_index do. NB. free space
            NB. append a boxed . to disk SIZE times
            disk =. disk , (; size) # <'.' 
        else. NB. file
            NB. append the boxed fileID to disk SIZE times
            disk =. disk , (; size) # < fileID
            fileID =. fileID + 1
        end.
    end.
    disk
)

NB. Move file segments into free spaces
fragment =: 3 : 0
    spaces =. I. y = <'.' NB. indices of free spaces
    files =. |. I. y ~: <'.' NB. indices of files in reverse order
    index =. 0
    for_space. spaces do.
        if. space > index { files do.
            break. NB. this space is to the right of this file, so we're done
        end.
        NB. replace current space with  current file segment
        y =. ((index { files) { y) space } y
        NB. replace current file segment with space
        y =. (<'.') (index { files) } y
        index =. index + 1
    end.
    y
)

NB. Calculate the checksum
checksum =: 3 : 0
    ints =. (<0) (I. y = (<'.')) } y 
    +/ (i. # ints) * ; ints
)

NB. Move files into free spaces, contiguously
defragment =: 3 : 0
    NB. make a backwards list of even integers half the length of y
    file_ids =. |. i.(>. -: (#y))
    disk =. expand y

    for_fid. file_ids do.
        positions =. (< fid) I.@:E. disk NB. indices of file ID in disk map
        file =. (# positions) # (< fid) NB. full size file
        space =. (# positions) # <'.' NB. same sized space
        space_enough =. {. space I.@:E. disk NB. find earliest big enough free space
        if. space_enough *. space_enough < {. positions do.
            disk =. (file) (space_enough +i.#file) } disk NB. replace free space with file
            disk =. (space) (positions) } disk NB. replace file with free space
        end.
    end.
    disk
)

NB. Read input
NB.input =: fread 'input.txt'
input =: '2333133121414131402'
ints =: ". each input

NB. Part 1
disk =: expand ints
fragmented =: fragment disk
echo checksum fragmented

NB. Part 2
defragmented =: defragment ints
echo checksum defragmented
