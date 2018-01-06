#! /usr/bin/awk
# You can change ht (height) and wid (width) and ox (offset of x axis) with following values in cmd:
#  "-v ht=N"
#  "-v wid=N" 
#  "-v ox=N"

BEGIN {
	if (!(ht))
		ht = 40   # Default for height
	if (!(wid))
		wid = 100 # Default for width
	if (!(ox))
		ox = 10   # Default for offset of x axis
	oy = 2
	number = "^[+-]?([0-9]+[.]?[0-9]*|[.][0-9]+)([eE][+=]?[0-9]+)?$"
	botlab = "Test graph" # Default for Description 
}

$1 == "label" { # Description for buttom of graph
	sub(/^ *label */, "")
	botlab = $0
	next
}

$1 == "bottom" && $2 == "ticks" { # Ticks for x axis
	for (i = 3; i <= NF; i++)
		bticks[++nb] = $i
	next
}

$1 == "left" && $2 == "ticks" { # Ticks for y axis
	for (i = 3; i <= NF; i++)
		lticks[++nl] = $i
	next
}

$1 == "range" { # Min and max of x and y axes
	xmin = $2
	ymin = $3
	xmax = $4
	ymax = $5
	next
}

$1 == "height" { # Change default or command defined value of height
	ht = $2
	next
}

$1 == "width" { # Change default or command defined value of width
	wid = $2
	next
}

$1 == "offset" && $2 == "x" { # Change default or command defined value of ox
	ox = $3
	next
}

$1 ~ number && $2 ~ number { # X and Y
	nd++
	x[nd] = $1
	y[nd] = $2
	ch[nd] = $3
	next
}

$1 ~ number && $2 !~ number {
	nd++
	x[nd] = nd
	y[nd] = $1
	ch[nd] = $2
	next
}

END {
	if (xmin == "") { # Without range
		xmin = xmax = x[1]
		ymin = ymax = y[1]
		for (i = 2; i <= nd; i++) {
			if (x[i] < xmin)
				xmin = x[i]
			if (x[i] > xmax) 
				xmax = x[i]
			if (y[i] < ymin)
				ymin = y[i]
			if (y[i] > ymax) 
				ymax = y[i]
		}
	}
	frame()
	ticks()
	label()
	data()
	draw()
}

function frame() {
	for (i = ox; i < wid; i++)
		plot(i, oy, "-")       # bottom
	for (i = ox; i < wid; i++)
		plot(i, ht-1, "-")     # top
	for (i = oy; i < ht; i++)
		plot(ox, i, "|")       # left
	for (i = oy; i < ht; i++)
		plot(wid-1, i, "|")    # right
}

function ticks(i) { # Create tick marks for x and y axes
	for (i = 1; i <= nb; i++) {
		plot(xscale(bticks[i]), oy, "|")
		splot(xscale(bticks[i])-1, 1, bticks[i])
	}
	for (i = 1; i <= nl; i++) {
		plot(ox, yscale(lticks[i]), "-")
		splot(0, yscale(lticks[i]), lticks[i])
	}
}

function label() { # Center under x axis 
	splot(int((wid + ox - length(botlab))/2), 0, botlab)
}

function data(i) { # Data points
	for (i = 1; i <= nd; i++)
		plot(xscale(x[i]), yscale(y[i]), ch[i]=="" ? "*" : ch[i])
}

function draw(i, j) { # Print from array
	for (i = ht-1; i >= 0; i--) {
		for (j = 0; j < wid; j++)
			printf((j,i) in array ? array[j,i] : " ")
		printf("\n")
	}
}

function xscale(x) { # Scale of x value
	return int((x-xmin)/(xmax-xmin) * (wid-1-ox) + ox + 0.5)
}

function yscale(y) { # Scale of y value
	return int((y-ymin)/(ymax-ymin) * (ht-1-oy) + oy + 0.5)
}

function plot(x, y, c) { # Put char in array
	array[x,y] = c
}

function splot(x, y, s, i, n) { # Put str in array
	n = length(s)
	for (i = 0; i < n; i++)
		array[x+i, y] = substr(s, i+1, 1)
}
