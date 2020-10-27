# STM32F4xx Blink

This repository contains a minimal "blink" project for the STM32F401RE microprocessor (on a Nucleo-64 development board). The main purpose is to demonstrate how to compile STM32F4 projects to include the relevant STM HAL dependencies.

For details on environment setup (toolchain etc.) see the [STM32F4 Basic](https://github.com/sdiemert/stm32f4-basic) repository.

## Usage

Build the project using: 

```
make
```

Then you can upload to the STM32F4xx microcontroller using the ST Link utility with:

```
make flash
```

Clean using:

```
make clean
```
