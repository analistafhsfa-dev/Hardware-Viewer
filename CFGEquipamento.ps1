Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$Xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Info Computadores"
    Width="950"
    Height="700"
    MinWidth="750"
    MinHeight="550"
    WindowStartupLocation="CenterScreen"
    Background="#F3F4F6">

    <Grid Margin="15">

        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="10"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="10"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Border
            Grid.Row="0"
            Background="#1F2937"
            CornerRadius="6"
            Padding="15">

            <Grid>

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="250"/>
                    <ColumnDefinition Width="100"/>
                    <ColumnDefinition Width="90"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0">

                    <TextBlock
                        Text="Info Computadores"
                        Foreground="White"
                        FontSize="22"
                        FontWeight="Bold"/>

                    <TextBlock
                        Text="Consultas de hardware"
                        Foreground="#D1D5DB"
                        FontSize="12"
                        Margin="0,3,0,0"/>

                </StackPanel>

                <TextBox
                    x:Name="TxtHost"
                    Grid.Column="1"
                    Height="34"
                    Margin="10,0,8,0"
                    VerticalContentAlignment="Center"
                    Padding="8"
                    FontSize="14"
                    ToolTip="Digite o nome ou IP da m quina"/>

                <Button
                    x:Name="BtnConsultar"
                    Grid.Column="2"
                    Height="34"
                    Margin="0,0,8,0"
                    Content="Consultar"
                    FontWeight="Bold"/>

                <Button
                    x:Name="BtnLimpar"
                    Grid.Column="3"
                    Height="34"
                    Content="Limpar"/>

            </Grid>

        </Border>

        <Border
            Grid.Row="2"
            Background="#111827"
            BorderBrush="#374151"
            BorderThickness="1"
            CornerRadius="6"
            Padding="10">

            <TextBox
                x:Name="TxtResultado"
                IsReadOnly="True"
                AcceptsReturn="True"
                AcceptsTab="True"
                TextWrapping="NoWrap"
                VerticalScrollBarVisibility="Auto"
                HorizontalScrollBarVisibility="Auto"
                FontFamily="Consolas"
                FontSize="13"
                Background="#111827"
                Foreground="#E5E7EB"
                BorderThickness="0"
                Padding="10"/>

        </Border>

        <StackPanel
            Grid.Row="4"
            Orientation="Horizontal">

            <TextBlock
                Text="Status:"
                FontWeight="Bold"
                Foreground="#374151"/>

            <TextBlock
                x:Name="TxtStatus"
                Text="Aguardando consulta..."
                Margin="5,0,0,0"
                Foreground="#6B7280"/>

        </StackPanel>

    </Grid>

</Window>
"@


$Reader = New-Object System.Xml.XmlNodeReader $Xaml
$Window = [Windows.Markup.XamlReader]::Load($Reader)

$TxtHost      = $Window.FindName("TxtHost")
$BtnConsultar = $Window.FindName("BtnConsultar")
$BtnLimpar    = $Window.FindName("BtnLimpar")
$TxtResultado = $Window.FindName("TxtResultado")
$TxtStatus    = $Window.FindName("TxtStatus")

function Write-Result {

    param(
        [string]$Text
    )

    $TxtResultado.AppendText($Text)
    $TxtResultado.ScrollToEnd()

    [System.Windows.Threading.Dispatcher]::CurrentDispatcher.Invoke(
        [Action]{},
        "Background"
    )
}

function Get-HardwareInfo {

    $Target = $TxtHost.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($Target)) {

        [System.Windows.MessageBox]::Show(
            "Digite o nome ou IP da m quina.",
            "Hardware Info",
            "OK",
            "Warning"
        )

        return
    }

    $BtnConsultar.IsEnabled = $false

    $TxtResultado.Clear()

    $TxtStatus.Text = "Consultando $Target..."
    $TxtStatus.Foreground = "#D97706"

    try {

        Write-Result "Maquina: $Target`r`n"
        Write-Result "Data:    $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')`r`n"
        Write-Result "============================================================`r`n"

        $Ping = Test-Connection `
            -ComputerName $Target `
            -Count 1 `
            -Quiet `
            -ErrorAction SilentlyContinue

        if (-not $Ping) {

            Write-Result "ERRO: Maquina inacessivel.`r`n"

            $TxtStatus.Text = "M quina inacess vel"
            $TxtStatus.Foreground = "#DC2626"

            return
        }

        Write-Result "OK - Maquina acessivel.`r`n"

        Write-Result "============================================================`r`n"
        Write-Result "*PROCESSADOR*`r`n"
	Write-Result "`r`n"


        $CPU = Get-WmiObject `
            -Class Win32_Processor `
            -ComputerName $Target `
            -ErrorAction Stop


        foreach ($Processor in $CPU) {

            Write-Result "Nome           : $($Processor.Name)`r`n"
            Write-Result "Nucleos        : $($Processor.NumberOfCores)`r`n"
            Write-Result "Threads        : $($Processor.NumberOfLogicalProcessors)`r`n"
            Write-Result "Clock Maximo   : $($Processor.MaxClockSpeed) MHz`r`n"
            Write-Result "`r`n"
        }

        Write-Result "============================================================`r`n"
        Write-Result "*MEMORIA RAM*`r`n"
        Write-Result "`r`n"

        $Computer = Get-WmiObject `
            -Class Win32_ComputerSystem `
            -ComputerName $Target `
            -ErrorAction Stop


        $RAMGB = [math]::Round(
            $Computer.TotalPhysicalMemory / 1GB,
            2
        )


        #Write-Result "Fabricante     : $($Computer.Manufacturer)`r`n"
        #Write-Result "Modelo         : $($Computer.Model)`r`n"
        Write-Result "Memoria         : $RAMGB GB`r`n"
        Write-Result "`r`n"

        Write-Result "============================================================`r`n"
        Write-Result "*PLACA-MAE*`r`n"
        Write-Result "`r`n"

        $Board = Get-WmiObject `
            -Class Win32_BaseBoard `
            -ComputerName $Target `
            -ErrorAction Stop


        foreach ($Item in $Board) {

            Write-Result "Fabricante     : $($Item.Manufacturer)`r`n"
            Write-Result "Produto        : $($Item.Product)`r`n"
            Write-Result "Serial         : $($Item.SerialNumber)`r`n"
            Write-Result "`r`n"
        }

        Write-Result "============================================================`r`n"
        Write-Result "*HD / SSD*`r`n"
        Write-Result "`r`n"

        $Disks = Get-WmiObject `
            -Class Win32_DiskDrive `
            -ComputerName $Target `
            -ErrorAction Stop

        foreach ($Disk in $Disks) {

            if ($Disk.Size) {
                $SizeGB = [math]::Round(
                    $Disk.Size / 1GB,
                    2
                )
            }
            else {
                $SizeGB = 0
            }

            Write-Result "Modelo         : $($Disk.Model)`r`n"
            Write-Result "Tamanho        : $SizeGB GB`r`n"
            Write-Result "Serial         : $($Disk.SerialNumber)`r`n"
            Write-Result "`r`n"
        }

        $TxtStatus.Text = "Consulta conclu da com sucesso"
        $TxtStatus.Foreground = "#16A34A"

    }
    catch {

        Write-Result "`r`n"
        Write-Result "============================================================`r`n"
        Write-Result " ERRO NA CONSULTA`r`n"
        Write-Result "============================================================`r`n"
        Write-Result "$($_.Exception.Message)`r`n"
        Write-Result "`r`n"
        Write-Result "Possiveis causas:`r`n"
        Write-Result " - WMI remoto desabilitado`r`n"
        Write-Result " - Firewall bloqueando WMI/DCOM`r`n"
        Write-Result " - Credenciais sem permissao administrativa`r`n"
        Write-Result " - Servico Windows Management Instrumentation parado`r`n"

        $TxtStatus.Text = "Erro na consulta"
        $TxtStatus.Foreground = "#DC2626"
    }
    finally {

        $BtnConsultar.IsEnabled = $true
    }
}


# ============================================================
# BOT O CONSULTAR
# ============================================================

$BtnConsultar.Add_Click({

    Get-HardwareInfo
})


# ============================================================
# ENTER NO CAMPO HOST
# ============================================================

$TxtHost.Add_KeyDown({

    param($Sender, $EventArgs)

    if ($EventArgs.Key -eq "Return") {

        Get-HardwareInfo
    }
})


# ============================================================
# BOT O LIMPAR
# ============================================================

$BtnLimpar.Add_Click({

    $TxtResultado.Clear()

    $TxtStatus.Text = "Aguardando consulta..."
    $TxtStatus.Foreground = "#6B7280"

    $TxtHost.Focus()
})


# ============================================================
# INICIAR
# ============================================================

# ============================================================
# INICIAR
# ============================================================

$Window.Add_ContentRendered({
    $TxtHost.Focus() | Out-Null
})

$null = $Window.ShowDialog()