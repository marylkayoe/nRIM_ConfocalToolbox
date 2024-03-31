# Introduction to InputParser in MATLAB

`InputParser` is a MATLAB class that allows you to manage inputs to your functions more effectively. It enables you to define required inputs, optional inputs, and name-value pair arguments. This makes your functions more flexible and user-friendly, particularly when dealing with a large number of parameters or optional settings.

In simple terms, the function inputparser generates a "PARSER" object - kind of a small robot - that will help you to check the inputs of your function. It will check if the inputs are correct, and if not, it will throw an error. It will also help you to assign default values to the inputs if they are not provided by the user. After the parser object has parsed the inputs, you can ask it to give you the values of the inputs using the `Results` property. (So, the results of the parsing work end up stored in the `Results` property (structure) of the parser object.)

## Step 1: Create an instance of the InputParser class

Before using `InputParser`, you need to create an instance of this class within your function.

```matlab
parser = inputParser;
```

Now the variable "parser" is a parser object ready to be used. (Again, think of an object kind of like a small robot.)


## Step 2: Define required inputs
Use the addRequired method to specify which inputs are required for your function. Each required input needs a name, and you can optionally provide a validation function to ensure the input meets certain criteria.

```matlab
parser.addRequired('neuron_id', @ischar);
```
## Step 3: Define optional inputs
Optional inputs can be added using the addOptional method. This method is similar to addRequired, but includes a default value in case the user doesn't specify one.

```matlab
parser.addOptional('dendritic_length', [], @isnumeric);
```

## Step 4: Define name-value pair arguments
Name-value pair arguments offer the most flexibility, allowing users to specify optional settings by name. Use the addParameter method for this.
    
    ```matlab
    parser.addParameter('calcium_signals', [], @isnumeric);
parser.addParameter('neurotransmitter', 'unknown', @ischar);
```

## Step 5: Parse the inputs
Once all inputs have been defined, use the parse method to apply the InputParser configuration to the actual inputs provided to your function.
    
    ```matlab
    parser.parse(varargin{:});
```

## Step 6: Accessing the parsed inputs
After parsing, you can access the input values through the Results property of the parser object.
    
    ```matlab
    neuron_id = parser.Results.neuron_id;
dendritic_length = parser.Results.dendritic_length;
 ```

 ## Example Function
Here's a complete example of a function that uses InputParser:

```matlab
function create_neuron(varargin)
    parser = inputParser;
    parser.addRequired('neuron_id', @ischar);
    parser.addOptional('dendritic_length', [], @isnumeric);
    parser.addParameter('calcium_signals', [], @isnumeric);
    parser.addParameter('neurotransmitter', 'unknown', @ischar);
    
    parser.parse(varargin{:});
    
    neuron.neuron_id = parser.Results.neuron_id;
    neuron.dendritic_length = parser.Results.dendritic_length;
    neuron.calcium_signals = parser.Results.calcium_signals;
    neuron.neurotransmitter = parser.Results.neurotransmitter;
    
    % Here you can further process the neuron structure as needed
    disp(neuron);
end
```

## Using the Function
To use the function with a mix of required, optional, and name-value pair arguments:
    
    ```matlab
    create_neuron('N1', 5, 'calcium_signals', [0.5, 0.7, 0.9], 'neurotransmitter', 'GABA');
```


