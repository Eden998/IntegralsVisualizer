# Integrals Calculator

Eden Yosef

Language: Java

IDE: Processing

Integrals Calculator and visualizer

# General Description

This is an integrals calculator with visualization, written in Java language.

While learning Calculus 2, I came up with this idea to make an integral calculator, The calculation is being made with Riemann's method for calculating integrals.

# How To Use

### Sliders:

In the main window there are 2 sliders:

* *Upper slider* - Controls the interval where you want to calculate the integral.
* *Lower slider* - Controls the density of the partitions.

You can change both max and min values by clicking on the "Change" button next to them.

### Grid Size:

You can change the grid size with the mouse scroll wheel.

### Function:

If you want to change the function, you need to change it in line 438 in the code.

### Demonstration of the program:

![Integral Calculator Gif](https://github.com/Eden998/IntegralsVisualizer/blob/main/images/integrals.gif)

# Riemann's method

## Mathmatical explanation
A Riemann sum is a certain kind of approximation of an integral by a finite sum.

![Reimann's method](https://github.com/Eden998/ProcessingProjects/blob/main/Integrals/images/reimann.png)

## Code Implementation

```Processing
integral_sum = 0;
float square_size = (SCREEN_SIZE / (GRID_SIZE * 2.0));
for(int i = 0; i < intergral_dens_slider.currVal ; i++)
{
 float left = range_slider.currLeftVal + (range_slider.currRightVal - range_slider.currLeftVal) * (float(i) /intergral_dens_slider.currVal);
 float right = range_slider.currLeftVal + (range_slider.currRightVal - range_slider.currLeftVal) * (float(i + 1) /intergral_dens_slider.currVal);
 float leftPos = SCREEN_SIZE / 2 + left * square_size;
 float rightPos = SCREEN_SIZE / 2 + right * square_size;
 float rect_high = calc_func((right + left) / 2) * (-1) * square_size;
 integral_sum += ((rightPos - leftPos) * rect_high) / pow(square_size, 2);
}
```




