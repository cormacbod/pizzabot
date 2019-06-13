# README

The pizzabot application takes in a set of parameters that define 
a 2-Dimensional Cartesian grid and a set of points within that grid.
It outputs a set of instructions to move from the origin to each 
of the points in the input, depositing a pizza at each of those points.

## Requirements

* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (app was written with Ruby 2.3.7)
* [RSpec](https://rspec.info/) (RSpec 3.8.0 was used)

## Running Pizzabot as an executable
* The pizzabot app can be run from a terminal command line
* Check permissions for the `lib/pizzabot` file using:
    ```
    ls -l lib/pizzabot
    ```
    The ouput should look like this
    ```
    -rwxr-xr-x  1 username  staff  805 Jun  9 13:42 lib/pizzabot
    ```
    if the x's are missing from the `-rwxr-xr-x` part you can add them in using:
    ```
    chmod 755 lib/pizzabot
    ```
* Check path settings

    Type `echo $PATH`  at the command line prompt and look for `/usr/local/bin/` in the output.
    
    If it is missing, add it in by entering `mkdir -p /usr/local/bin/`
    
    Finally, associate lib/pizzabot with this by entering `ln -s $PWD/lib/pizzabot /usr/local/bin/`
    
    You can now run pizzabot from the command line by typing:
    ```
    pizzabot "5x5 (1, 3) (4,4)"
    ```
    for example.
    
## Running Pizzabot as a Ruby Script
* At the root directory of the project enter:
    ``` 
    ruby lib/pizzabot "5x5 (1, 3) (4,4)"
    ```
    for example
    
## Input Parameter Format
* The command line arguments for the pizzabot application must be enclosed in quotation marks
* There are 2 parts to the command line arguments
  - Grid Dimensions: These take the format -
    ```
    #{integer}x#{integer}
    ``` 
    and must come at the beginning of the argument string.
    Only the grid dimensions at the beginning of the string are used. Grid dimensions elsewhere elsewhere are ignored.
  - Delivery Location Coordinates:  These take the format - 
    ```
    (#{integer},#{integer})
    ```
     There can be many or no delivery location coordinates
    and whitespace within and between them is ignored.
   
## How to run the test suite
* If RSpec has been installed, you can run the test suite by typing `rspec` at the root directory of the project.