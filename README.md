# Geo Quantum
ARRUMAR V EM calc_IV_curve

Python software for nanodiode development using the Monte Carlo Method applied to the classical Drude model.

## Table of Contents

- [Background](#background)
- [Prerequisites](#prerequisites)
- [Install](#install)
- [Usage](#usage)
	- [UI interface] (#ui interface)
	- [Outputs] (#outputs)
- [Examples](#examples)
- [Maintainers](#maintainers)
- [License](#license)

## Background

The software "Nanodiode Conda" was developed during the master's degree in electrical engineering at the Federal Center for Technological Education of Minas Gerais (CEFET-MG) with the purpose of simulating electronic transport in nanodiodes when subjected to a potential difference between its terminals (anode and cathode) from the perspective of the Monte Carlo Method (MCM).

The Drude Model is considered in this modeling.

Two optimization algorithms are available for geometry, one being mono-objective and the other multi-objective.

The implementation was done in the python language, with three main packages: [scikit-geometry](https://github.com/scikit-geometry/scikit-geometry), [scipy](https://scipy.org/), and [pymoo](https://pymoo.org/).

The objectives of this repository are:
1. Open-source implementation of the **Drude model** for electronic transport simulation;
2. Use of the **Monte Carlo Method** for classical particle simulation in a material medium;
3. Implementation of two **optimization** routines for geometry: **Differential Evolution** and **NSGA-II**.

## Prerequisites
This project uses the [scikit-geometry](https://github.com/scikit-geometry/scikit-geometry) library, which is available on [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html). A conda interpreter is recommended.

The python version used in the project is 3.9. The versions of the other packages used are available in the [requirements.txt](requirements.txt) file.

## Install
Clone the [diode_conda](https://github.com/thiagohgmello1/diode_conda.git) repository into a new local folder.
Create a conda environment in the project folder. Activate it and install the packages from [requirements.txt](requirements.txt):

```sh
$ conda install --yes --file requirements.txt
```
If the installation of the **scikit-geometry** package is not completed, install it manually.


## Usage
The simulation uses 5 parse arguments, which are:

- **single**: Defines a simulation file. Allows simulation of only one configuration (e.g., "folder1/folder2/.../folderN/file");
- **multi**: Defines a simulation directory. Allows simulation of multiple configurations sequentially (e.g., "folder1/folder2/.../folderN");
- **output**: Defines a folder for saving output data (e.g., "folder1/folder2/.../folderM");
- **id**: Defines an identifier for the simulation (e.g., "sim_1");
- **opt**: Enables optimization (e.g., "true").

Execution example:
```
.../main.py --single input_examples/rectangle --output current_output --id test_id --opt false
```

It is strongly recommended to configure templates. All folders must be identified from the project root. More details about the arguments can be obtained through the parse arguments help.

The file containing the simulation settings is in "json" format with 6 main keys: **material**, **particle**, **geometry**, **convergence**, **voltage**, **optimizer**, with "optimizer" required only when optimization is needed.

### Material

Defines the material properties. **Mandatory** parameters:

| Parameter             | Type  | Unit  | Description                    |          Example |
|-----------------------|:-----:|-------|--------------------------------|-----------------:|
| mean_free_path        | float | m     | Mean free path of the material |           200e-9 |
| carrier_concentration | dict  | -     | Carrier concentration          | (detailed below) |
| scalar_fermi_velocity | float | m/s   | Fermi velocity                 |              1e6 |

**Non-mandatory** parameters:

| Parameter      | Type  | Unit     | Description                    | Example |
|----------------|:-----:|----------|--------------------------------|--------:|
| mobility       | float | m^2/(Vs) | Electron mobility              |  0.7380 |
| relax_time     | float | s        | Relaxation time                |   1e-12 |
| permittivity   | float | 1        | Material relative permittivity |       1 |
| permeability   | float | 1        | Material relative permeability |       1 |
| effective_mass | float | 1        | electron effective mass        |    0.02 |

#### carrier_concentration
The carrier concentration must be defined using the **method** key, with possible values being "gate_voltage" (gate voltage, in volts), "temp" (temperature, in kelvin), or "value" (specific value, in carrier/$m^{2}$). Examples of carrier_concentration:

```
"carrier_concentration": {
  "method": "gate_voltage",
  "gate_voltage": 1,
  "substrate_thickness": 1e-8
}
```

```
"carrier_concentration": {
  "method": "temp",
  "temp": 300
}
```

```
"carrier_concentration": {
  "method": "value",
  "value": 7.2e15
}
```


### Particle

Characterizes the traveling particle in the material medium. **Mandatory** parameters:

| Parameter    |  Type  | Unit               | Description                                         |   Example |
|--------------|:------:|--------------------|-----------------------------------------------------|----------:|
| density      | float  | electrons/particle | Particle density                                    |        10 |
| drift_method | string | -                  | Defines how to calculate the particle's drift speed | ''relax'' |


### Geometry

Defines the simulated geometry. **Mandatory** parameters:

| Parameter   |  Type  | Unit | Description                     |          Example |
|-------------|:------:|------|---------------------------------|-----------------:|
| input_style | string | -    | Defines the geometry input type | (detailed below) |
| scale       | float  | 1    | Geometry scale                  |  1e-9 (nm scale) |

**Non-mandatory** parameter:

| Parameter    | Type | Unit | Description                              |                   Example |
|--------------|:----:|------|------------------------------------------|--------------------------:|
| cur_segments | list | -    | Defines the edges for current accounting | [[1],[4]] (edges 1 and 4) |

The first list contains the anode terminals and the second the cathode terminals. If "cur_segments" is not used, edge definition is done graphically via an interactive window.

#### input_style
The simulated geometry data input can be through an **XML** file or via points. If it's an image, "input_style" is "file"; otherwise, it's "points". Examples:

```
"points": [[[0,0], [6,0.5], [6,9.5], [0,10], [0,9.5], [0,0.5]]]
```

```
"file_name": "test.svg"
```

### Convergence
Defines numerical convergence parameters for the simulation. **Mandatory** parameters:

| Parameter       |  Type  | Unit      | Description                                           |          Example |
|-----------------|:------:|-----------|-------------------------------------------------------|-----------------:|
| max_coll        | float  | 1         | Maximum number of particle collisions with boundaries |              1e5 |
| n_particles     | float  | particles | Number of particles                                   |                1 |
| geo             | string | -         | Simulated geometry name (for identification only)     |        rectangle |
| check_condition | string | -         | Particle simulation termination condition             | (detailed below) |

#### check_condition
Can be "time" or "distance".
- ''time'' checks the end of a particle's simulation based on the time it traveled in the material. It's based on the relaxation time;
- ''distance'' checks the end of a particle's simulation based on the distance it traveled in the material. It's based on the mean free path (**recommended**).

Examples:
```
"check_condition": "time"
```
```
"check_condition": "distance"
```


### Voltage
Parameterization of the voltages applied to the geometry for the voltage/current graph. Not used when optimization is applied. **Mandatory** parameters:

| Parameter  | Type  | Unit | Description                        | Example |
|------------|:-----:|------|------------------------------------|--------:|
| v_min      | float | V    | Minimum voltage                    |    -0.1 |
| v_max      | float | V    | Maximum voltage                    |     0.1 |
| num_points |  int  | -    | Number of simulated voltage points |      11 |


### Optimizer
Optimizer configuration. **Mandatory** parameters:

| Parameter |  Type  | Unit | Description             |          Example |
|-----------|:------:|------|-------------------------|-----------------:|
| type      | string | -    | Optimization type       | (detailed below) |
| params    |  dict  | -    | Optimization parameters | (detailed below) |

#### type
The optimization type can be "numpy" for mono-objective optimization or "pymoo" for multi-objective optimization.
An example configuration is below:

Mono-objective example:
```
"type": "numpy"
```

Multi-objective example:
```
"type": "pymoo"
```

#### params
The parameters depend on the type of simulation.

For **single-objective** optimization:

| Parameter     | Type  | Unit | Description                      |                                         Example |
|---------------|:-----:|------|----------------------------------|------------------------------------------------:|
| pop_size      |  int  | -    | Population size                  |                                              20 |
| max_iter      |  int  | -    | Maximum iterations               |                                              20 |
| mutation      | float | -    | Mutation rate                    |                                             0.5 |
| recombination | float | -    | Recombination of generations     |                                             0.5 |
| polish        | bool  | -    | Generation polishing             |                                           false |
| objectives    | dict  | -    | Objective function configuration | (detailed in [Mono-Objective](#mono-objective)) |
| constraints   | list  | -    | Optimization constraints         | (detailed in [Mono-Objective](#mono-objective)) |
| bounds        | list  | -    | Variable bounds                  |     (detailed in [Optimization](#optimization)) |
| geo_mask      | list  | -    | Geometry mask                    |     (detailed in [Optimization](#optimization)) |
| cur_segments  | list  | -    | Segments for current calculation |     (detailed in [Optimization](#optimization)) |

For **multi-objective** optimization:

| Parameter     | Type  | Unit | Description                       |                                           Example |
|---------------|:-----:|------|-----------------------------------|--------------------------------------------------:|
| pop_size      |  int  | -    | Population size                   |                                                20 |
| max_iter      |  int  | -    | Maximum iterations                |                                                20 |
| objectives    | dict  | -    | Objective functions configuration | (detailed in [Multi-Objective](#multi-objective)) |
| constraints   | list  | -    | Optimization constraints          | (detailed in [Multi-Objective](#multi-objective)) |
| bounds        | list  | -    | Variable bounds                   |       (detailed in [Optimization](#optimization)) |
| geo_mask      | list  | -    | Geometry mask                     |       (detailed in [Optimization](#optimization)) |
| cur_segments  | list  | -    | Segments for current calculation  |       (detailed in [Optimization](#optimization)) |


## Optimization
The goal of optimization is to find the best topology that minimizes/maximizes the objective function(s).
More details can be found in the master thesis related to this work and in optimization textbooks.
For this, two python packages are used: [scipy](https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.differential_evolution.html) and [pymoo](https://pymoo.org/).

The management of the optimized variables is done through the string "xN", where N is the variable number starting from "0". For example, "x0" is variable 0, "x1" is variable 1, and so on. The numerical order must be followed.

#### bounds
The definition of the possible range for each variable follows the order of their definition (x0, x1, x2,...) and follows the pattern:

```
[[a,b],[c,d],...[m,n]]
```

with "[a,b]" being the bounds for variable x0 ($a < x0 < b$), "[c,d]" the bounds for variable x1 ($c < x1 < d$), and so on. A complete example of the key is:

```
"bounds": [[5,50], [15, 50]]
```

#### geo_mask
"geo_mask" is a mask for the geometry, allowing points in space to be found from the variables. Consider the previous example of bounds and the following mask configuration:

```
"geo_mask": [[0,0], ["x1",0], ["x1","x2"], ["x2",0]]
```

With it, a rectangle is constructed with points {(0, 0), (x1,0), (x1,x2), (x2,0)}.

#### cur_segments
Defines the anode(s) and cathode(s) of the diode. It is given in the form:

```
"cur_segments": [[1],[4]]
```

The first list refers to the anode(s) and the second to the cathode(s). The definition of segments is made from the points. In the previous example of points, {(0, 0), (x1,0)} is edge 0, {(x1,0), (x1,x2)} is edge 1, and so on.

### Mono-Objective
Mono-objective optimization allows for the optimization of only one objective function at a time.

#### objectives
The objective and its configurations are defined according to the example:

```
"objectives": {
  "derivative": "numerical",
  "method": "ZBI",
  "voltage_range": [-0.1, 0 , 0.1]
}
```

Here, "derivative" defines whether the derivative calculation is numerical (key "numerical") or by polynomial fitting (key "fit"). If polynomial fitting is used, the key "poly_order" should be added in "objectives", whose value indicates the order of the approximation.

The "method" key is responsible for indicating the objective function, which can be **ZBI** for zero-bias resistance or **ZBR** for zero-bias responsivity.
The "voltage_range" key defines the points used in the calculation of the objective function.

#### constraints
Defines the simulation constraints. It has the form:

```
"constraints": [["lambda x: x[1] / x[2]", "3", "np.inf"]]
```
which means a list of lists of size 3, where the elements of the inner list are strings, with the variables in the "x" vector respecting the mask definition.
The first term is the lambda function, the second is the lower bound of the inequality, and the third is the upper bound of the inequality.
Mathematically, the example is read as $3 < x1/x2 < \infty$.

### Multi-Objective
Multi-objective optimization allows for the simultaneous optimization of two objective functions.

#### objectives
The objectives and its configurations are defined according to the example:

```
"objectives": {
  "derivative": "numerical",
  "methods": ["ZBI", "ZBR"],
  "voltage_range": [-0.1, 0 , 0.1]
}
```

"derivative" follows the same pattern as in the mono-objective case.  The "methods" key is a list, whose possible values are **ZBI** and **ZBR**.
The "voltage_range" key follows the same pattern as in the mono-objective case.

#### constraints
Defines the simulation constraints. It has the form:

```
"constraints": ["lambda x: x[1] / x[2] - 3"]
```

which means a list of size M, with M being the number of constraints. Mathematically, the example is read as $x1/x2 \geq 3$.

More details are available on the [constraints](https://pymoo.org/constraints/index.html) page of pymoo.


## Examples
Examples of formatting for simulations without optimization and with mono- and multi-objective optimizations are in the **input_examples** folder.

| Simulation | Geometry  | Optimization |
|------------|:---------:|--------------|
| opt_mono   | arrowhead | Yes (scipy)  |
| opt_multi  | arrowhead | Yes (pymoo)  |
| rectangle  | rectangle | No           |

After selecting the file, for cases without optimization and without prior definition of current edges, a window opens with a button, whose function is to graphically select the current edges.
To do this, click the window button labeled "Current" and click with the left mouse button on the edges corresponding to the positive terminal. With the right mouse button, select the edges corresponding to the negative terminal.
The selected edges will turn red or blue, depending on the expected polarity.


## Maintainers

[@thiagohgmello1](https://github.com/thiagohgmello1) (e-mail: thiagohgmello@gmail.com).


## License

[BSD 3-Clause](LICENSE) © Thiago Henrique Gonçalves Mello