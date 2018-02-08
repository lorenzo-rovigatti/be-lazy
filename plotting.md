---

# Plotting

There exists a lot of software devoted to the production of scientific (or more in general, data) plots. However, almost every single scientific community has its own preferred tool. The most common in my own community are [xmgrace](http://plasma-gate.weizmann.ac.il/Grace/), gnuplot, Mathematica and matplotlib.

## xmgrace

For unknown (but mostly historical, I suppose) reasons, many people in the water/numerical soft matter communities love to use [xmgrace](http://plasma-gate.weizmann.ac.il/Grace/). It is ugly, old and supports 2D graphics only, but if your PhD advisor uses it, chances are you will have to get used to it as well :smile:

### Improve the default style

There is no other way of putting it: the default xmgrace style sucks. Hard. The great majority of the people who start using it goes through the process of setting up the graph style for every single plot they need to prepare.
Fortunately, xmgrace provides an easy way out: 

* take an empty `agr` file and edit its style to suit your needs
* name it `Default.agr` and place it in the `~/.grace/templates/` folder. Note that it might be necessary to create the folder beforehand

My `Default.agr`, which can be used as a starting point to make your own custom style, is included in the `misc` folder.

### ~~Add colours~~
