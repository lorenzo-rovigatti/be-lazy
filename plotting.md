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

### Upgrade the default colours

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
