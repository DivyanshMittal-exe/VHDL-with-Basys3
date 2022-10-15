# Ml in VHDL
This assignment is an exercise to implement machine vision through neural network hardware. We design a
3-layer Multi-layer Perceptron (MLP) for the vision task. The hardware, implemented on the Basys3 board,
will take as input patterns from the MNIST dataset, and will classify it into one of 10 digit categories.
This assignment involves the design and integration of memories, registers, comparator, shifter and multiplieraccumulator components (MAC) in your design.

We implement a 3-layer neural network inference in VHDL and test it on Basys3 board. Input (28x28 or 1x784 when flattened), Hidden Layer 1 (1x64) and Output Layer (1x10). The network has been pre-trained on MNIST dataset (Weights: 784x64 and 64x10, Biases: 64 and 10) 

## FSM
![FSM](./python/Blank%20diagram.png)

## Connections
![FSM](./python/Blank%20diagram%20(1).png)