function aoc4(){
  // prompt for input file
  var filename, file; // semicolons are only strictly necessary after var declarations
  
  switch (os_type)
  { // in my GML days I always put open braces on their own lines
    // I also really loved switch-cases
  	case os_windows: filename = get_open_filename("text file|*.txt", ""); break
  	default: filename = get_string("Please specify the full path of your input file:", "")
  }
  
  if (filename != "")
  { 
      file = file_text_open_read(filename)
  }

  // read lines
  var n = 0;
  while (!file_text_eof(file))
  {
  	lines[n++] = file_text_readln(file)
  }

  // assemble grid
  wordsearch = ds_grid_create(string_length(lines[0]), array_length(lines))
  for (var i = 0; i < ds_grid_height(wordsearch); i++)
  {
  	for (var j = 0; j < ds_grid_width(wordsearch); j++)
  	{
  		wordsearch[# i, j] = string_char_at(lines[i], j+1)
  	}
  }

  // find xmases
  var	xmas_count = 0;
  for (var v = 0; v < ds_grid_height(wordsearch); v++)
  {
  	for (var h = 0; h < ds_grid_width(wordsearch); h++)
  	{
  		if (wordsearch[# h, v] = "X") // = and == are equivalent in GML
  		{
  			// east
  			if (h < ds_grid_width(wordsearch) - 3)
  			and (wordsearch[# h + 1, v] = "M")
  			and (wordsearch[# h + 2, v] = "A")
  			and (wordsearch[# h + 3, v] = "S")
  				xmas_count++
  			// west
  			if (h >= 3)
  			and (wordsearch[# h - 1, v] = "M")
  			and (wordsearch[# h - 2, v] = "A")
  			and (wordsearch[# h - 3, v] = "S")
  				xmas_count++
  			// south
  			if (v < ds_grid_height(wordsearch) - 3)
  			and (wordsearch[# h, v + 1] = "M")
  			and (wordsearch[# h, v + 2] = "A")
  			and (wordsearch[# h, v + 3] = "S")
  				xmas_count++
  			// north
  			if (v >= 3)
  			and (wordsearch[# h, v - 1] = "M")
  			and (wordsearch[# h, v - 2] = "A")
  			and (wordsearch[# h, v - 3] = "S")
  				xmas_count++

  			// southeast
  			if (h < ds_grid_width(wordsearch) - 3)
                               and (v < ds_grid_height(wordsearch) - 3)
  			and (wordsearch[# h + 1, v + 1] = "M")
  			and (wordsearch[# h + 2, v + 2] = "A")
  			and (wordsearch[# h + 3, v + 3] = "S")
  				xmas_count++

  			// southwest
  			if (h >= 3) and (v < ds_grid_height(wordsearch) - 3)
  			and (wordsearch[# h - 1, v + 1] = "M")
  			and (wordsearch[# h - 2, v + 2] = "A")
  			and (wordsearch[# h - 3, v + 3] = "S")
  				xmas_count++

  			// northeast
  			if (h < ds_grid_width(wordsearch) - 3) and (v >= 3)
  			and (wordsearch[# h + 1, v - 1] = "M")
  			and (wordsearch[# h + 2, v - 2] = "A")
  			and (wordsearch[# h + 3, v - 3] = "S")
  				xmas_count++

  			// northwest
  			if (h >= 3) and (v >= 3)
  			and (wordsearch[# h - 1, v - 1] = "M")
  			and (wordsearch[# h - 2, v - 2] = "A")
  			and (wordsearch[# h - 3, v - 3] = "S")
  				xmas_count++
  		}
  	}
  }

  show_message_async("XMASs: " + string(xmas_count))

  // part two: find x-mases
  var x_mas_count = 0;
  for (v = 0; v < ds_grid_height(wordsearch); v++)
  {
  	for (h = 0; h < ds_grid_width(wordsearch); h++)
  	{
  		if (wordsearch[# h, v] = "M")
  		{
  			if (h < ds_grid_width(wordsearch) - 2)
                               and (v < ds_grid_height(wordsearch) - 2)
  			and (wordsearch[# h + 2, v] = "M")
  			and (wordsearch[# h + 1, v + 1] = "A")
  			and (wordsearch[# h, v + 2] = "S")
  			and (wordsearch[# h + 2, v + 2] = "S")
  				x_mas_count++
  			else if (h < ds_grid_width(wordsearch) - 2)
                               and (v < ds_grid_height(wordsearch) - 2)
  			and (wordsearch[# h + 2, v] = "S")
  			and (wordsearch[# h + 1, v + 1] = "A")
  			and (wordsearch[# h, v + 2] = "M")
  			and (wordsearch[# h + 2, v + 2] = "S")
  				x_mas_count++
  		}
  		else if (wordsearch[# h, v] = "S")
  		{
  			if (h < ds_grid_width(wordsearch) - 2)
                               and (v < ds_grid_height(wordsearch) - 2)
  			and (wordsearch[# h + 2, v] = "M")
  			and (wordsearch[# h + 1, v + 1] = "A")
  			and (wordsearch[# h, v + 2] = "S")
  			and (wordsearch[# h + 2, v + 2] = "M")
  				x_mas_count++
  			else if (h < ds_grid_width(wordsearch) - 2)
                               and (v < ds_grid_height(wordsearch) - 2)
  			and (wordsearch[# h + 2, v] = "S")
  			and (wordsearch[# h + 1, v + 1] = "A")
  			and (wordsearch[# h, v + 2] = "M")
  			and (wordsearch[# h + 2, v + 2] = "M")
  				x_mas_count++
  		}
  	}
  }

  // show result
  show_message_async("X-MASs: " + string(x_mas_count))
}
