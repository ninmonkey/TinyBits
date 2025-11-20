Add-Type -AssemblyName System.Windows.Forms

[Windows.Forms.Button] $exitButton = @{
    Location = [Drawing.Point]@{ x = 10; y = 30; }
    Padding  = [Windows.Forms.Padding]@{ all = 8 }
    Name     = 'ExitButton'
    Text     = 'button text...'
    TabIndex = 4
    UseVisualStyleBackColor = $false
}

# $exitButton.add_ ... etc

<#

how do you get the right names?

Ex: use the constructor's name, without arguments. It prints the overloads:

    > [Windows.Forms.Padding]::new

        OverloadDefinitions
        -------------------
        public Padding(int all);
        public Padding(int left, int top, int right, int bottom);

Using a hashtable on a type will call the matching constructor if possible

    > [type]@{}

Examples:

    [Windows.Forms.Padding]@{ all = 8 }
    [Windows.Forms.Padding]@{ left = 10;  top = 30; }
    [Windows.Forms.Padding]@{ left = 10;  top = 30; right = 100; bottom = 200 }
#>
