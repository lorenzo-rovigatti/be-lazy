---

# Plotting

There exists a lot of software devoted to the production of scientific (or more in general, data) plots. However, almost every single scientific community has its own preferred tool. The most common in my own community are [xmgrace](http://plasma-gate.weizmann.ac.il/Grace/), gnuplot, Mathematica and matplotlib.

## xmgrace

For unknown (but mostly historical, I suppose) reasons, many people in the water/numerical soft matter communities love to use [xmgrace](http://plasma-gate.weizmann.ac.il/Grace/). It is ugly, old and supports 2D graphics only, but if your PhD advisor uses it, chances are you will have to get used to it as well :smile:

### Improve the default style

There is no other way of putting it: the default xmgrace style sucks. Hard. The great majority of the people who start using it goes through the process of setting up the graph style for every single plot they need to prepare.
Fortunately, xmgrace provides an easy way out: 

* Take an empty `agr` file and edit its style to suit your needs.
* Name it `Default.agr` and place it in the `~/.grace/templates/` folder. Note that it might be necessary to create the folder beforehand.

My actual `Default.agr`, which can be used as a starting point to make your own custom style, is included in the `misc` folder.

### Change the default colours

The default xmgrace colour palette is quite lackluster, to say the least. Luckily, it is very easy to change the default colours. Open your `Default.agr` (see previous section) and look for the `@map color` lines. Add any line you want (taking care not to have repeated colour indeces), or change the existing ones. Colours should be specified with the RGB format and are always fully opaque.

Once you are done just save the file and open `xmgrace`. You will be greeted by a (hopefully) much more colourful palette!

For instance, the following lines (contained in the `misc/Default.agr` example file)

```
@map color 0 to (255, 255, 255), "white"
@map color 1 to (0, 0, 0), "black"
@map color 2 to (227,26,28), "red"
@map color 3 to (51,160,44), "green"
@map color 4 to (31,100,180), "blue"
@map color 5 to (255, 127, 0), "orange"
@map color 6 to (106,61,154), "violet"
@map color 7 to (177,89,40), "brown"
@map color 8 to (220, 220, 220), "grey"
@map color 9 to (251,154,153), "light red"
@map color 10 to (178,223,138), "light green"
@map color 11 to (166,206,227), "light blue"
@map color 12 to (253,191,111), "light orange"
@map color 13 to (202,178,214), "lilla"
@map color 14 to (212,184,127), "light brown"
@map color 15 to (139, 0, 0), "red4"
@map color 16 to (0, 139, 0), "green4"
@map color 17 to (0, 0, 139), "blue4"
@map color 18 to (139, 139, 139), "grey4"
```

generate the colour palette shown below

![The colour palette specified in the `/misc/Default.agr`](images/xmgrace_palette.png)

**Nota Bene:** the colour palette of old plots (or of plots generated on computers that use a different `Default.agr`) will not be affected. However, plots generated with your own style will look the same wherever you (or anyone else) will open them!

### Scripting xmgrace

Scripting xmgrace is not as straightforward nor as powerful as it is for other similar software such as gnuplot. However, together with Bash (or Python or any other scripting language) it can be used to make the automatic generation of plots a bit easier.

We will start with an example. Prepare a plottable datafile and call it `my_data.dat`. Copy the content of the following box to a file (`batch.xmg`, for example):

```
READ NXY "my_data.dat"
PRINT TO "my_data.eps"
DEVICE "EPS" OP "level2"
PRINT
```

Now call `gracebat -batch batch.xmg -nosafe`. The `gracebat` executable is part of xmgrace and it is used when there is no need to start up the GUI. We pass it a simple script that loads up the datafile and tells xmgrace to print it as an eps file using the standard style. Note that we have to include the `-nosafe` option or xmgrace will refuse to run some commands such as `PRINT`. Block data can be read by using the appropriate command, for example

```
READ BLOCK "my_data.dat"
BLOCK xy "1:3"
```

will create a new `xy` set with the first and third columns of the datafile.

**Nota Bene:** You may use batch files that do not explicitly read from any datafile by passing those datafiles directly to the executable, *e.g.* `gracebat -batch batch.xmg -nosafe my_data.dat` or `gracebat -batch batch.xmg -nosafe -block my_data.dat -bxy 1:3`.

The style of the plot can be changed by using the same commands that are found in the `.agr` files. The best way of learning them is to prepare a plot with the style you want to use, save it and open it with your preferred text editor. You can then straightforwardly copy and paste any line you want to your batch file (omitting the starting `@' sign). For example, with the following box you can set the ranges, labels and ticks of the axes, as well as the style and legend of the first set:

```
WORLD XMIN 0
WORLD XMAX 25
WORLD YMIN 0
WORLD YMAX 1
xaxis label "x"
xaxis tick major 5
yaxis label "y"
yaxis tick minor ticks 4
s0 line type 0
s0 symbol 1
s0 symbol size 1.5
s0 legend "Experiments"
```

The full list of commands can be found in the [official documentation](http://plasma-gate.weizmann.ac.il/Grace/doc/UsersGuide.html#s5).


### Miscellaneous tips & tricks

* To copy & paste use `ctrl + insert` and `shift + insert`. Your default OS shortcuts do not work. On Linux, you can also use the mouse middle button.