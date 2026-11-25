
# ============================================================
# INFO COMPUTADORES - VERSAO 2.1
# ============================================================
# Interface profissional de inventario de hardware
#
# Funcionalidades:
# - Consulta por IP
# - Consulta por nome do computador
# - Busca por numero de identificacao
# - Identificacao FHSFA / FHSFASL
# - Informacoes de CPU, RAM, placa-mae e discos
#
# ============================================================

$ErrorActionPreference = "Stop"

# ============================================================
# BIBLIOTECAS
# ============================================================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# ============================================================
# INTERFACE XAML
# ============================================================

[xml]$Xaml = @"

<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Info Computadores"
    Width="1050"
    Height="800"
    MinWidth="850"
    MinHeight="650"
    WindowStartupLocation="CenterScreen"
    Background="#F3F4F6">

    <Window.Resources>

        <Style x:Key="CardStyle" TargetType="Border">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="CornerRadius" Value="10"/>
            <Setter Property="Padding" Value="18"/>
            <Setter Property="Margin" Value="6"/>
            <Setter Property="BorderBrush" Value="#E5E7EB"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

        <Style x:Key="TitleStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#6B7280"/>
            <Setter Property="Margin" Value="0,0,0,12"/>
        </Style>

        <Style x:Key="ValueStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="15"/>
            <Setter Property="Foreground" Value="#111827"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
            <Setter Property="Margin" Value="0,3,0,3"/>
        </Style>

        <Style x:Key="DetailStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Foreground" Value="#6B7280"/>
            <Setter Property="Margin" Value="0,4,0,0"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
        </Style>

    </Window.Resources>

    <Grid Margin="15">

        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="12"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="12"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- CABECALHO -->

        <Border
            Grid.Row="0"
            Background="#1F2937"
            CornerRadius="10"
            Padding="18">

            <Grid>

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="240"/>
                    <ColumnDefinition Width="105"/>
                    <ColumnDefinition Width="85"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0">

                    <TextBlock
                        Text="INFO COMPUTADORES"
                        Foreground="White"
                        FontSize="21"
                        FontWeight="Bold"/>

                    <TextBlock
                        Text="Gerenciamento e inventario de hardware"
                        Foreground="#D1D5DB"
                        FontSize="12"
                        Margin="0,4,0,0"/>

                </StackPanel>

                <TextBox
                    x:Name="TxtHost"
                    Grid.Column="1"
                    Height="36"
                    Margin="8,0"
                    VerticalContentAlignment="Center"
                    Padding="8"
                    FontSize="14"
                    ToolTip="Digite o nome ou IP da maquina"/>

                <Button
                    x:Name="BtnConsultar"
                    Grid.Column="2"
                    Height="36"
                    Margin="3,0"
                    Content="Consultar"
                    FontWeight="Bold"
                    Background="#2563EB"
                    Foreground="White"
                    BorderThickness="0"
                    Cursor="Hand"/>

                <Button
                    x:Name="BtnLimpar"
                    Grid.Column="3"
                    Height="36"
                    Margin="3,0"
                    Content="Limpar"
                    Background="#374151"
                    Foreground="White"
                    BorderThickness="0"
                    Cursor="Hand"/>

            </Grid>

        </Border>

        <!-- AREA DE RESULTADOS -->

        <Border
            Grid.Row="2"
            Background="#E5E7EB"
            CornerRadius="10"
            Padding="8">

            <ScrollViewer
                VerticalScrollBarVisibility="Auto"
                HorizontalScrollBarVisibility="Disabled">

                <StackPanel>

                    <!-- IDENTIFICACAO DO COMPUTADOR -->

                    <Border
                        Style="{StaticResource CardStyle}"
                        Background="#FFFFFF">

                        <Grid>

                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0">

                                <TextBlock
                                    Text="IDENTIFICACAO DO COMPUTADOR"
                                    Style="{StaticResource TitleStyle}"/>

                                <TextBlock
                                    x:Name="TxtNomeComputador"
                                    Text="Aguardando consulta..."
                                    FontSize="22"
                                    FontWeight="Bold"
                                    Foreground="#111827"/>

                                <TextBlock
                                    x:Name="TxtDataConsulta"
                                    Text="Data da consulta: --"
                                    Style="{StaticResource DetailStyle}"/>

                            </StackPanel>

                            <Border
                                Grid.Column="1"
                                Background="#F3F4F6"
                                CornerRadius="8"
                                Padding="12"
                                VerticalAlignment="Center">

                                <StackPanel
                                    Orientation="Horizontal">

                                    <Ellipse
                                        x:Name="LedStatus"
                                        Width="10"
                                        Height="10"
                                        Fill="#9CA3AF"
                                        Margin="0,0,8,0"/>

                                    <TextBlock
                                        x:Name="TxtConectividade"
                                        Text="Aguardando"
                                        FontWeight="SemiBold"
                                        Foreground="#6B7280"/>

                                </StackPanel>

                            </Border>

                        </Grid>

                    </Border>

                    <!-- PROCESSADOR E MEMORIA -->

                    <Grid>

                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>

                        <!-- PROCESSADOR -->

                        <Border
                            Grid.Column="0"
                            Style="{StaticResource CardStyle}">

                            <StackPanel>

                                <TextBlock
                                    Text="PROCESSADOR"
                                    Style="{StaticResource TitleStyle}"/>

                                <TextBlock
                                    Text="CPU"
                                    FontSize="11"
                                    Foreground="#2563EB"
                                    FontWeight="Bold"/>

                                <TextBlock
                                    x:Name="TxtCPU"
                                    Text="--"
                                    FontSize="18"
                                    FontWeight="Bold"
                                    Foreground="#111827"
                                    TextWrapping="Wrap"
                                    Margin="0,5,0,12"/>

                                <Separator Margin="0,3,0,8"/>

                                <TextBlock
                                    x:Name="TxtCPUNucleos"
                                    Text="Nucleos: --"
                                    Style="{StaticResource ValueStyle}"/>

                                <TextBlock
                                    x:Name="TxtCPUThreads"
                                    Text="Threads: --"
                                    Style="{StaticResource ValueStyle}"/>

                                <TextBlock
                                    x:Name="TxtCPUClock"
                                    Text="Clock: --"
                                    Style="{StaticResource ValueStyle}"/>

                            </StackPanel>

                        </Border>

                        <!-- MEMORIA RAM -->

                        <Border
                            Grid.Column="1"
                            Style="{StaticResource CardStyle}">

                            <StackPanel>

                                <TextBlock
                                    Text="MEMORIA RAM"
                                    Style="{StaticResource TitleStyle}"/>

                                <TextBlock
                                    x:Name="TxtRAM"
                                    Text="-- GB"
                                    FontSize="32"
                                    FontWeight="Bold"
                                    Foreground="#2563EB"
                                    Margin="0,5,0,5"/>

                                <TextBlock
                                    Text="Memoria fisica total"
                                    FontSize="12"
                                    Foreground="#6B7280"/>

                                <Separator Margin="0,15,0,10"/>

                                <TextBlock
                                    x:Name="TxtRAMDetalhes"
                                    Text="Aguardando informacoes..."
                                    Style="{StaticResource ValueStyle}"/>

                            </StackPanel>

                        </Border>

                    </Grid>

                    <!-- PLACA MAE -->

                    <Border
                        Style="{StaticResource CardStyle}">

                        <StackPanel>

                            <TextBlock
                                Text="PLACA-MAE"
                                Style="{StaticResource TitleStyle}"/>

                            <TextBlock
                                x:Name="TxtBoardFabricante"
                                Text="Fabricante: --"
                                Style="{StaticResource ValueStyle}"/>

                            <TextBlock
                                x:Name="TxtBoardModelo"
                                Text="Modelo: --"
                                Style="{StaticResource ValueStyle}"/>

                            <TextBlock
                                x:Name="TxtBoardSerial"
                                Text="Numero de serie: --"
                                Style="{StaticResource ValueStyle}"/>

                        </StackPanel>

                    </Border>

                    <!-- ARMAZENAMENTO -->

                    <Border
                        Style="{StaticResource CardStyle}">

                        <StackPanel>

                            <TextBlock
                                Text="ARMAZENAMENTO"
                                Style="{StaticResource TitleStyle}"/>

                            <TextBlock
                                x:Name="TxtTotalDiscos"
                                Text="Unidades encontradas: 0"
                                Foreground="#6B7280"
                                FontSize="12"
                                Margin="0,0,0,10"/>

                            <StackPanel
                                x:Name="PanelDiscos"/>

                        </StackPanel>

                    </Border>

                    <!-- MENSAGEM DE ERRO -->

                    <Border
                        x:Name="CardErro"
                        Background="#FEF2F2"
                        BorderBrush="#FECACA"
                        BorderThickness="1"
                        CornerRadius="8"
                        Padding="15"
                        Margin="6"
                        Visibility="Collapsed">

                        <StackPanel>

                            <TextBlock
                                Text="ERRO NA CONSULTA"
                                FontWeight="Bold"
                                Foreground="#DC2626"
                                FontSize="14"/>

                            <TextBlock
                                x:Name="TxtErro"
                                Text=""
                                Foreground="#991B1B"
                                FontSize="12"
                                TextWrapping="Wrap"
                                Margin="0,8,0,0"/>

                        </StackPanel>

                    </Border>

                </StackPanel>

            </ScrollViewer>

        </Border>

        <!-- STATUS -->

        <Border
            Grid.Row="4"
            Background="#FFFFFF"
            CornerRadius="6"
            Padding="10">

            <DockPanel>

                <StackPanel
                    Orientation="Horizontal"
                    DockPanel.Dock="Left">

                    <TextBlock
                        Text="STATUS:"
                        FontWeight="Bold"
                        Foreground="#374151"/>

                    <TextBlock
                        x:Name="TxtStatus"
                        Text="Aguardando consulta..."
                        Margin="7,0,0,0"
                        Foreground="#6B7280"/>

                </StackPanel>

                <TextBlock
                    Text="INFO COMPUTADORES | V3.0"
                    Foreground="#9CA3AF"
                    FontSize="11"
                    HorizontalAlignment="Right"
                    DockPanel.Dock="Right"/>

            </DockPanel>

        </Border>

    </Grid>

</Window>

"@

# ============================================================
# CARREGAMENTO DA INTERFACE
# ============================================================

$Reader = New-Object System.Xml.XmlNodeReader $Xaml

$Window = [Windows.Markup.XamlReader]::Load($Reader)

# Controles

$TxtHost = $Window.FindName("TxtHost")

$BtnConsultar = $Window.FindName("BtnConsultar")
$BtnLimpar = $Window.FindName("BtnLimpar")

$TxtStatus = $Window.FindName("TxtStatus")

$TxtNomeComputador = $Window.FindName("TxtNomeComputador")
$TxtDataConsulta = $Window.FindName("TxtDataConsulta")

$LedStatus = $Window.FindName("LedStatus")
$TxtConectividade = $Window.FindName("TxtConectividade")

$TxtCPU = $Window.FindName("TxtCPU")
$TxtCPUNucleos = $Window.FindName("TxtCPUNucleos")
$TxtCPUThreads = $Window.FindName("TxtCPUThreads")
$TxtCPUClock = $Window.FindName("TxtCPUClock")

$TxtRAM = $Window.FindName("TxtRAM")
$TxtRAMDetalhes = $Window.FindName("TxtRAMDetalhes")

$TxtBoardFabricante = $Window.FindName("TxtBoardFabricante")
$TxtBoardModelo = $Window.FindName("TxtBoardModelo")
$TxtBoardSerial = $Window.FindName("TxtBoardSerial")

$TxtTotalDiscos = $Window.FindName("TxtTotalDiscos")
$PanelDiscos = $Window.FindName("PanelDiscos")

$CardErro = $Window.FindName("CardErro")
$TxtErro = $Window.FindName("TxtErro")

# ============================================================
# LOCALIZAR COMPUTADOR
# ============================================================

function Test-ComputerExists {

    param(
        [string]$ComputerName
    )

    try {

        $Result = Resolve-DnsName `
            -Name $ComputerName `
            -Type A `
            -ErrorAction Stop

        return ($null -ne $Result)

    }
    catch {

        return $false

    }

}

# ============================================================
# RESOLVER NOME DO COMPUTADOR
# ============================================================

function Resolve-ComputerTarget {

    param(
        [string]$InputName
    )

    $InputName = $InputName.Trim()

    # Se for IP

    if ($InputName -match '^\d{1,3}(\.\d{1,3}){3}$') {

        return $InputName

    }

    # Se digitou somente numeros

    if ($InputName -match '^\d+$') {

        $Computer1 = "fhsfa$InputName"
        $Computer2 = "fhsfasl$InputName"

        $Exists1 = Test-ComputerExists $Computer1
        $Exists2 = Test-ComputerExists $Computer2

        if ($Exists1 -and $Exists2) {

            $Choice = [System.Windows.MessageBox]::Show(

                "Foram encontrados dois computadores:`n`n" +
                "SIM = $Computer1`n" +
                "NÃO = $Computer2`n`n" +
                "Deseja consultar $Computer1?",

                "Selecionar computador",

                [System.Windows.MessageBoxButton]::YesNoCancel,

                [System.Windows.MessageBoxImage]::Question

            )

            switch ($Choice) {

                "Yes" {
                    return $Computer1
                }

                "No" {
                    return $Computer2
                }

                default {
                    return $null
                }

            }

        }

        if ($Exists1) {
            return $Computer1
        }

        if ($Exists2) {
            return $Computer2
        }

        return $null

    }

    return $InputName

}

# ============================================================
# CRIAR CARTAO DE DISCO
# ============================================================

function Add-DiskCard {

    param(
        [string]$Model,
        [string]$Type,
        [string]$Size,
        [string]$Serial
    )

    $Card = New-Object System.Windows.Controls.Border

    $Card.Background = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#F9FAFB")
    $Card.BorderBrush = [System.Windows.Media.BrushConverter]::new().ConvertFromString("#E5E7EB")
    $Card.BorderThickness = New-Object System.Windows.Thickness(1)
    $Card.CornerRadius = New-Object System.Windows.CornerRadius(8)
    $Card.Padding = New-Object System.Windows.Thickness(12)
    $Card.Margin = New-Object System.Windows.Thickness(0,0,0,8)

    $Stack = New-Object System.Windows.Controls.StackPanel

    $Title = New-Object System.Windows.Controls.TextBlock
    $Title.Text = $Type
    $Title.FontSize = 13
    $Title.FontWeight = "Bold"
    $Title.Foreground = [System.Windows.Media.Brushes]::DarkSlateBlue

    $Stack.Children.Add($Title) | Out-Null

    $ModelText = New-Object System.Windows.Controls.TextBlock
    $ModelText.Text = "Modelo: $Model"
    $ModelText.FontSize = 13
    $ModelText.Foreground = [System.Windows.Media.Brushes]::Black
    $ModelText.TextWrapping = "Wrap"
    $ModelText.Margin = New-Object System.Windows.Thickness(0,7,0,3)

    $Stack.Children.Add($ModelText) | Out-Null

    $SizeText = New-Object System.Windows.Controls.TextBlock
    $SizeText.Text = "Capacidade: $Size GB"
    $SizeText.FontSize = 13
    $SizeText.Foreground = [System.Windows.Media.Brushes]::Black

    $Stack.Children.Add($SizeText) | Out-Null

    $SerialText = New-Object System.Windows.Controls.TextBlock
    $SerialText.Text = "Serial: $Serial"
    $SerialText.FontSize = 11
    $SerialText.Foreground = [System.Windows.Media.Brushes]::Gray
    $SerialText.TextWrapping = "Wrap"
    $SerialText.Margin = New-Object System.Windows.Thickness(0,5,0,0)

    $Stack.Children.Add($SerialText) | Out-Null

    $Card.Child = $Stack

    $PanelDiscos.Children.Add($Card) | Out-Null

}

# ============================================================
# LIMPAR RESULTADOS
# ============================================================

function Clear-HardwareInfo {

    $TxtNomeComputador.Text = "Aguardando consulta..."

    $TxtDataConsulta.Text = "Data da consulta: --"

    $LedStatus.Fill = [System.Windows.Media.Brushes]::Gray

    $TxtConectividade.Text = "Aguardando"

    $TxtCPU.Text = "--"
    $TxtCPUNucleos.Text = "Nucleos: --"
    $TxtCPUThreads.Text = "Threads: --"
    $TxtCPUClock.Text = "Clock: --"

    $TxtRAM.Text = "-- GB"
    $TxtRAMDetalhes.Text = "Aguardando informacoes..."

    $TxtBoardFabricante.Text = "Fabricante: --"
    $TxtBoardModelo.Text = "Modelo: --"
    $TxtBoardSerial.Text = "Numero de serie: --"

    $TxtTotalDiscos.Text = "Unidades encontradas: 0"

    $PanelDiscos.Children.Clear()

    $CardErro.Visibility = "Collapsed"

}

# ============================================================
# CONSULTAR HARDWARE
# ============================================================

function Get-HardwareInfo {

    $InputName = $TxtHost.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($InputName)) {

        [System.Windows.MessageBox]::Show(
            "Digite o nome ou IP da maquina.",
            "Hardware Info",
            "OK",
            "Warning"
        )

        return

    }

    $Target = Resolve-ComputerTarget -InputName $InputName

    if ([string]::IsNullOrWhiteSpace($Target)) {

        $TxtStatus.Text = "Computador nao encontrado ou operacao cancelada."
        $TxtStatus.Foreground = "#DC2626"

        return

    }

    $TxtHost.Text = $Target

    $BtnConsultar.IsEnabled = $false

    Clear-HardwareInfo

    $TxtNomeComputador.Text = $Target

    $TxtStatus.Text = "Consultando $Target..."

    $TxtStatus.Foreground = "#D97706"

    try {

        # ----------------------------------------------------
        # TESTE DE CONECTIVIDADE
        # ----------------------------------------------------

        $Ping = Test-Connection `
            -ComputerName $Target `
            -Count 1 `
            -Quiet `
            -ErrorAction SilentlyContinue

        if (-not $Ping) {

            $LedStatus.Fill = [System.Windows.Media.Brushes]::Red

            $TxtConectividade.Text = "Inacessivel"

            $TxtStatus.Text = "Computador inacessivel."

            $TxtStatus.Foreground = "#DC2626"

            return

        }

        $LedStatus.Fill = [System.Windows.Media.Brushes]::Green

        $TxtConectividade.Text = "Online"

        $TxtDataConsulta.Text = "Data da consulta: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"

        # ----------------------------------------------------
        # PROCESSADOR
        # ----------------------------------------------------

        $CPU = Get-WmiObject `
            -Class Win32_Processor `
            -ComputerName $Target `
            -ErrorAction Stop

        $Processor = $CPU | Select-Object -First 1

        $TxtCPU.Text = $Processor.Name.Trim()

        $TxtCPUNucleos.Text = "Nucleos: $($Processor.NumberOfCores)"

        $TxtCPUThreads.Text = "Threads: $($Processor.NumberOfLogicalProcessors)"

        $Clock = [math]::Round($Processor.MaxClockSpeed / 1000, 2)

        $TxtCPUClock.Text = "Clock maximo: $Clock GHz"

        # ----------------------------------------------------
        # MEMORIA RAM
        # ----------------------------------------------------

        $Computer = Get-WmiObject `
            -Class Win32_ComputerSystem `
            -ComputerName $Target `
            -ErrorAction Stop

        $RAMGB = [math]::Round(
            $Computer.TotalPhysicalMemory / 1GB,
            2
        )

        $TxtRAM.Text = "$RAMGB GB"

        $TxtRAMDetalhes.Text = "Memoria fisica total instalada"

        # ----------------------------------------------------
        # PLACA MAE
        # ----------------------------------------------------

        $Board = Get-WmiObject `
            -Class Win32_BaseBoard `
            -ComputerName $Target `
            -ErrorAction Stop

        $Item = $Board | Select-Object -First 1

        $TxtBoardFabricante.Text = "Fabricante: $($Item.Manufacturer)"

        $TxtBoardModelo.Text = "Modelo: $($Item.Product)"

        $TxtBoardSerial.Text = "Numero de serie: $($Item.SerialNumber)"

        # ----------------------------------------------------
        # ARMAZENAMENTO
        # ----------------------------------------------------

        $Disks = Get-WmiObject `
            -Class Win32_DiskDrive `
            -ComputerName $Target `
            -ErrorAction Stop

        $PanelDiscos.Children.Clear()

        $DiskCount = @($Disks).Count

        $TxtTotalDiscos.Text = "Unidades encontradas: $DiskCount"

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

            # Identificacao do tipo de unidade.
            # O WMI nem sempre informa corretamente SSD/HDD.

            $Model = $Disk.Model

            $MediaType = [string]$Disk.MediaType

            if ($Model -match "SSD|NVMe" -or $MediaType -match "SSD") {

                $Type = "SSD"

            }
            elseif ($MediaType -match "Fixed hard disk") {

                $Type = "HD / HDD"

            }
            else {

                $Type = "Disco - Tipo nao identificado"

            }

            Add-DiskCard `
                -Model $Model `
                -Type $Type `
                -Size $SizeGB `
                -Serial $Disk.SerialNumber

        }

        # ----------------------------------------------------
        # FINALIZACAO
        # ----------------------------------------------------

        $TxtStatus.Text = "Consulta concluida com sucesso."

        $TxtStatus.Foreground = "#16A34A"

    }
    catch {

        $CardErro.Visibility = "Visible"

        $TxtErro.Text = $_.Exception.Message

        $TxtStatus.Text = "Erro na consulta."

        $TxtStatus.Foreground = "#DC2626"

        $LedStatus.Fill = [System.Windows.Media.Brushes]::Red

        $TxtConectividade.Text = "Erro"

    }
    finally {

        $BtnConsultar.IsEnabled = $true

    }

}

# ============================================================
# BOTAO CONSULTAR
# ============================================================

$BtnConsultar.Add_Click({

    Get-HardwareInfo

})

# ============================================================
# ENTER PARA CONSULTAR
# ============================================================

$TxtHost.Add_KeyDown({

    param($Sender, $EventArgs)

    if ($EventArgs.Key -eq "Return") {

        Get-HardwareInfo

    }

})

# ============================================================
# BOTAO LIMPAR
# ============================================================

$BtnLimpar.Add_Click({

    Clear-HardwareInfo

    $TxtHost.Clear()

    $TxtStatus.Text = "Aguardando consulta..."

    $TxtStatus.Foreground = "#6B7280"

    $TxtHost.Focus()

})

# ============================================================
# INICIALIZAR
# ============================================================

$Window.Add_ContentRendered({

    $TxtHost.Focus() | Out-Null
})
$null = $Window.ShowDialog()
