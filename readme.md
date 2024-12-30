# Minesweeper in SystemVerilog

This repository contains the implementation of the classic Minesweeper game developed entirely in SystemVerilog. The project demonstrates expertise in digital design, modular programming, and hardware-software integration. It was developed as the final project for **ECE 385: Digital Systems Laboratory** at the University of Illinois Urbana-Champaign (UIUC). The game is designed to run on FPGA boards or in simulation environments, showcasing a complete hardware implementation of the game. This project was tested on the Spartan-7 Urbana FPGA board.


## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Files](#files)
- [How to Run](#how-to-run)
- [Implementation Details](#implementation-details)
  - [Modular Design](#modular-design)
  - [Random Mine Placement](#random-mine-placement)
  - [Grid Updates](#grid-updates)
  - [Display Logic](#display-logic)
  - [Scoring System](#scoring-system)
- [Testing](#testing)
- [Future Improvements](#future-improvements)
- [Acknowledgments](#acknowledgments)

## Overview
Minesweeper is a logic-based puzzle game where players reveal tiles on a grid, aiming to avoid hidden mines while uncovering clues about their locations. This implementation provides a hardware-centric version of the game, demonstrating advanced digital logic design concepts and the practical use of SystemVerilog.

The game includes a user-friendly interface, mine detection logic, and an interactive grid system. It is suitable for FPGA deployment or simulation, providing an immersive experience with real-time feedback.

## Features
- **Randomized Mine Placement**: Ensures a unique gameplay experience every time the game starts.
- **User Interaction**: Handles user input for tile selection, revealing safe tiles or mines.
- **Scoring Mechanism**: Tracks player performance and updates scores dynamically.
- **Game Over Detection**: Automatically ends the game when a mine is uncovered.
- **Optimized Hardware Utilization**: Designed to minimize resource usage on FPGA boards.

## Files
This repository contains the following file structure:

- **`font rom generator/`**: Contains the Python scripts and resources used to generate ROM files for the sprites. These scripts map the spritesheet into individual tile images and convert them into COE files for Vivado ROM IP integration.
- **`Minesweeper/`**: Includes all SystemVerilog source files for the Minesweeper game logic, including `mb_intro_top.sv`, `color_mapper.sv`, `minesweeper.sv`, `score_controller.sv`, and `sprite_controller.sv`.
- **`report/`**: Contains the project report detailing the design, implementation, and testing of the Minesweeper game.
- **`workspace/`**: A working directory used for compiling via Vitis, for Keyboard implementation in C.
- **`readme.md`**: This documentation file, which provides an overview of the project and instructions for setup, running, and deployment.

Overview of main `.sv` modules:
1. **`mb_intro_top.sv`**: The top-level module that orchestrates the overall game logic and interfaces with the hardware.
2. **`color_mapper.sv`**: A utility module for mapping grid states to colors for display purposes.
3. **`minesweeper.sv`**: Contains the core game logic, including mine placement, tile updates, and grid validation.
4. **`score_controller.sv`**: Manages score calculations and displays the current score.
5. **`sprite_controller.sv`**: Handles sprite rendering for visual representation of tiles, mines, and numbers.

## How to Run
### Requirements
- SystemVerilog simulation tool (e.g., ModelSim, Vivado, or Quartus Prime).
- Vitis IDE: Required for implementing keyboard functionality using C and integrating it with the FPGA system. This allows for efficient handling of keyboard inputs in the game.
- FPGA development board (optional, for hardware testing).

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/hscho421/FPGA-Mineswweeper.git
   ```
2. **Setup**:
   - Ensure all `.sv` files are in the same working directory.
   - Import the files into your simulation or FPGA project.
3. **Compile**:
   - Use your SystemVerilog simulator to synthesize, implement, and compile the files.
4. **Simulate**:
   - Run the simulation to interact with the game in a testbench environment.
5. **FPGA Deployment**:
   - Map inputs and outputs to appropriate pins on your FPGA board.
   - Synthesize the design and program it onto the board.

### Controls
- WASD keys: Cursor movement
- F key: Flag
- ESC key: Return to menu

## Implementation Details
### Modular Design
The project is divided into modular components to enhance readability, reusability, and testability. Each module focuses on a specific aspect of the game:
- **Core Logic**: Handled by the `minesweeper.sv` module.
- **Display Rendering**: Managed by the `sprite_controller.sv` and `color_mapper.sv` modules.
- **Score Tracking**: Implemented in the `score_controller.sv` module.

### Random Mine Placement
A pseudo-random number generator based on a Linear Feedback Shift Register (LFSR) ensures that mines are placed in random locations across the grid during initialization. The LFSR generates pseudo-random sequences by shifting bits through a series of flip-flops and applying XOR operations at specific taps, creating high-quality randomness suitable for hardware applications.


### Grid Updates
The game grid dynamically updates based on user actions. Each tile reveals its state:
- **Blank Tiles**: Indicate no adjacent mines.
- **Numbered Tiles**: Show the count of adjacent mines.
- **Mine Tiles**: Trigger a game over when clicked.

### Display Logic
The `sprite_controller.sv` and `color_mapper.sv` modules work together to render the grid visually. Tiles, mines, and numbers are represented using sprites that change dynamically.

A Python script was utilized to process the spritesheet, mapping it into individual tile images. These tiles were then converted into **COE (Coefficient) files**, which were subsequently integrated into the Vivado environment as ROM IP cores. This approach allowed efficient storage and retrieval of sprite data during gameplay, ensuring seamless visual updates.

### Scoring System
The `score_controller.sv` module tracks the player’s performance by:
- Awarding points for uncovering safe tiles.
- Penalizing points for incorrect actions.

## Testing
The project includes testbenches for verifying functionality:
- **Mine Placement Test**: Validates random distribution of mines.
- **Grid Update Test**: Ensures correct behavior when tiles are revealed.
- **Score Calculation Test**: Verifies accurate scoring based on player actions.

## Future Improvements
- **Customizable Grid Sizes**: Allow users to select grid dimensions.
- **Advanced Graphics**: Incorporate enhanced visual elements for improved user experience.
- **Difficulty Levels**: Add support for beginner, intermediate, and expert levels.
- **Multiplayer Mode**: Enable competitive or cooperative gameplay.
- **AI Player**: Introduce an AI opponent to assist or compete against the player.

## Acknowledgments
This project was developed as a demonstration of digital design and SystemVerilog programming. Special thanks to:
- SystemVerilog documentation and community resources.
- FPGA tools and simulators that made testing and deployment possible.

---
Feel free to contribute by submitting issues or pull requests. Suggestions for enhancements are always welcome!
