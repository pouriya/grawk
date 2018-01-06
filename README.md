# `grawk`
Simple [awk](https://en.wikipedia.org/wiki/AWK) script for generating simple ASCII graphs.


This script needs file (or input data) with following structure:
```graph
label caption
height number
width number
offset x number
range x-min y-min x-max y-max
left ticks t-1 t-2 ... t-n
bottom ticks t-1 t-2 ... t-n

x-value-1 y-value-1
x-value-2 y-value-2
...
x-value-n y-value-n
```

# Example
Suppose we want to create a graph from `sample.graph` file. This file contains:
```graph
label Test graph
height 23
width 80
offset x 3
range 0 0 100 100
left ticks 10 20 30 40 50 60 70 80 90
bottom ticks 10 20 30 40 50 60 70 80 90
5 5
10 10
15 15
20 20
25 25
30 30
35 35
40 40
45 45
50 50
55 55
60 60
65 65
70 70
75 75
80 80
85 85
90 90
95 95
```

Run command:
```sh
~/grawk $ awk -f grawk.awk sample.graph
   |---------------------------------------------------------------------------|
   |                                                                       *   |
90 -                                                                   *       |
   |                                                                *          |
80 -                                                            *              |
   |                                                        *                  |
70 -                                                    *                      |
   |                                                *                          |
60 -                                             *                             |
   |                                         *                                 |
50 -                                     *                                     |
   |                                 *                                         |
40 -                             *                                             |
   |                          *                                                |
30 -                      *                                                    |
   |                  *                                                        |
20 -              *                                                            |
   |          *                                                                |
10 -       *                                                                   |
   |   *                                                                       |
   |-------|------|-------|------|-------|-------|------|-------|------|-------|
          10     20      30     40      50      60     70      80     90        
                                    Test graph                                  
```

