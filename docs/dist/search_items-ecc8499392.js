searchNodes=[{"ref":"Day1.html","title":"Day1","type":"module","doc":""},{"ref":"Day1.html#calculate_additional_fuel/2","title":"Day1.calculate_additional_fuel/2","type":"function","doc":"Calculate the fuel required given a mass plus the additional fuel for carrying that fuel Examples iex&gt; Day1.calculate_additional_fuel(12) 2 iex&gt; Day1.calculate_additional_fuel(1969) 966 iex&gt; Day1.calculate_additional_fuel(100756) 50346"},{"ref":"Day1.html#calculate_fuel/1","title":"Day1.calculate_fuel/1","type":"function","doc":"Calculate the fuel required given a mass Examples iex&gt; Day1.calculate_fuel(12) 2 iex&gt; Day1.calculate_fuel(14) 2 iex&gt; Day1.calculate_fuel(1969) 654 iex&gt; Day1.calculate_fuel(100756) 33583"},{"ref":"Day1.html#solve/1","title":"Day1.solve/1","type":"function","doc":"Given a list of ints will calculate the fuel for each and sum the result uses calculate_fuel/1 to calculate fuel"},{"ref":"Day1.html#solve2/1","title":"Day1.solve2/1","type":"function","doc":"Given a list of ints will calculate the fuel + additional fuel for each and sum the result uses calculate_additional_fuel/1 to calculate fuel"},{"ref":"Intcode.html","title":"Intcode","type":"module","doc":"Intcode seems to be important this year for Advent of Code, so I&#39;m preemptively moving out some helper functions here."},{"ref":"Intcode.html#execute/1","title":"Intcode.execute/1","type":"function","doc":"Executes the instruction defined by the opcode at ip Returns a tuple of the new memory and the new instruction pointer. The new instruction pointer is found by incrementing the current instruction pointer by 1 + the number of parameters of this instruction. The instruction pointer can also be set by an instruction, and if it&#39;s value is :halt the program halts."},{"ref":"Intcode.html#execute/2","title":"Intcode.execute/2","type":"function","doc":"Executes the given intcode program in memory (a list of integers) and returns the memory after the program halts. This sets the instruction pointer to 0 initially."},{"ref":"Intcode.html#execute_instruction/3","title":"Intcode.execute_instruction/3","type":"function","doc":""},{"ref":"Intcode.html#execute_instruction/4","title":"Intcode.execute_instruction/4","type":"function","doc":""},{"ref":"Intcode.html#get_addr/2","title":"Intcode.get_addr/2","type":"function","doc":"Gets the value at address in memory"},{"ref":"Intcode.html#get_parameters_for_instruction/3","title":"Intcode.get_parameters_for_instruction/3","type":"function","doc":"Returns a list of all the parameters for the instruction as given by the ip (instruction pointer) and the number of parameters count from the memory"},{"ref":"Intcode.html#parse_instruction/2","title":"Intcode.parse_instruction/2","type":"function","doc":"Parses the instruction beginning at ip Returns a tuple of the instruction and it&#39;s parameters"},{"ref":"Intcode.html#update_instruction_pointer/2","title":"Intcode.update_instruction_pointer/2","type":"function","doc":""},{"ref":"Intcode.html#update_memory/2","title":"Intcode.update_memory/2","type":"function","doc":"Given the initial_memory applies the updates, which are {index, new_value} pairs"},{"ref":"Intcode.Instruction.html","title":"Intcode.Instruction","type":"module","doc":""},{"ref":"Intcode.Instruction.html#t:t/0","title":"Intcode.Instruction.t/0","type":"type","doc":"An opcode is a struct with a code (the integer that identifies it), the number of parameters. and an atom indicating the operation to perform."},{"ref":"Utils.html","title":"Utils","type":"module","doc":"Various Utility functions for solving advent of code problems."},{"ref":"Utils.html#get_input/3","title":"Utils.get_input/3","type":"function","doc":"Reads a file located at inputs/input-{day}-{part}.txt Options :stream if true will use File.stream!/1 defaults to File.read!/1 :split if true will split the input line by line Examples iex&gt; Utils.get_input(0, 0) &quot;Test File\\nWith Lines&quot; iex&gt; Utils.get_input(0, 0, split: true) [&quot;Test File&quot;, &quot;With Lines&quot;] iex&gt; Utils.get_input(0, 0, stream: true) |&gt; Stream.run :ok"},{"ref":"Utils.html#md5/1","title":"Utils.md5/1","type":"function","doc":"Generates the md5 hash of a value and encodes it as a lowercase base16 encoded string. Examples iex&gt; Utils.md5(&quot;advent of code&quot;) &quot;498fa12185ebe8a9231b9072da43c988&quot;"},{"ref":"Utils.html#permutations/1","title":"Utils.permutations/1","type":"function","doc":"Generates all the permutations for the input list Examples iex&gt; Utils.permutations([1, 2, 3]) [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]"},{"ref":"Utils.html#sample/2","title":"Utils.sample/2","type":"function","doc":"Inspects a value, but only if a random value generate is greater than threshold This is intended to be used with large streams of data that you want to investigate without printing every value."},{"ref":"Utils.html#swap/3","title":"Utils.swap/3","type":"function","doc":"Swaps the element at pos_a in list with the element at pos_b Examples iex&gt; Utils.swap([1, 2, 3], 0, 1) [2, 1, 3]"},{"ref":"Utils.html#time/1","title":"Utils.time/1","type":"function","doc":"Run the function fun and returns the time in seconds elapsed while running it"},{"ref":"Utils.Bitwise.html","title":"Utils.Bitwise","type":"module","doc":"Functions for manipulating bitstrings"},{"ref":"Utils.Bitwise.html#chunks/2","title":"Utils.Bitwise.chunks/2","type":"function","doc":"Breaks a binary in to n-length chunks of bits Examples iex&gt; Utils.Bitwise.chunks(&quot;abcd&quot;, 8) [&quot;a&quot;, &quot;b&quot;, &quot;c&quot;, &quot;d&quot;]"},{"ref":"Utils.Graph.html","title":"Utils.Graph","type":"module","doc":""},{"ref":"Utils.Graph.html#bfs/2","title":"Utils.Graph.bfs/2","type":"function","doc":"Performs a breadth first search starting at node The neighbors for node are determined by neighbors_fn From wikipedia, a BFS is: 1 procedure BFS(G,start_v): 2 let Q be a queue 3 label start_v as discovered 4 Q.enqueue(start_v) 5 while Q is not empty 6 v = Q.dequeue() 7 if v is the goal: 8 return v 9 for all edges from v to w in G.adjacentEdges(v) do 10 if w is not labeled as discovered: 11 label w as discovered 12 w.parent = v 13 Q.enqueue(w) but the challenge is to accomplish this w/ recursion The data structures we&#39;ll need to keep around are a queue, a map of discovered nodes, the current path We can overload the last two as a single map, with the map being from node -&gt; parent, where existing in the map indicates a node is discovered. The initial node with have a value of :start to indicate it has no parent We&#39;ll also take a function of v to return edges"},{"ref":"Utils.Graph.html#get_path/2","title":"Utils.Graph.get_path/2","type":"function","doc":"Given a map of nodes to parents (as a result of performing Utils.Graph.bfs/2) returns the path from goal to the start (or a node with no parent)."},{"ref":"Utils.List.html","title":"Utils.List","type":"module","doc":"A few functions for manipulating lists"},{"ref":"Utils.List.html#left_rotate/2","title":"Utils.List.left_rotate/2","type":"function","doc":"Rotates the list l by n elements left Examples iex&gt; Utils.List.left_rotate([1, 2, 3, 4], 1) [2, 3, 4, 1]"},{"ref":"Utils.List.html#right_rotate/2","title":"Utils.List.right_rotate/2","type":"function","doc":"Rotates the list l by n elements left Examples iex&gt; Utils.List.right_rotate([1, 2, 3, 4], 1) [4, 1, 2, 3]"},{"ref":"Utils.Matrix.html","title":"Utils.Matrix","type":"module","doc":"A few functions on top of the Matrex library for manipulating matrices."},{"ref":"Utils.Matrix.html#apply_to_sub_rect/6","title":"Utils.Matrix.apply_to_sub_rect/6","type":"function","doc":"Given a matrix will apply the function fun to every element in the sub-matrix starting at [x, y] with width w and height h"},{"ref":"Utils.Matrix.html#shift_col/3","title":"Utils.Matrix.shift_col/3","type":"function","doc":"Shifts the column x by amount"},{"ref":"Utils.Matrix.html#shift_row/3","title":"Utils.Matrix.shift_row/3","type":"function","doc":"Shifts the row y by amount Here we just transpose then shift_col/3 then transpose again"}]