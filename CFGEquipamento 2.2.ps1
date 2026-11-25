# ============================================================
# HardwareViewer - VERSAO 2.2
# ============================================================
# Consultas por IP, nome, FHSFA + numero ou FHSFASL + numero
# CPU, RAM, placa-mae e armazenamento
# ============================================================
$ErrorActionPreference = "Stop"
#Bibliotecas Utilizadas
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
# ============================================================
# INTERFACE
# ============================================================
[xml]$Xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Info Computadores"
    Width="610"
    Height="515"
    MinWidth="610"
    MinHeight="515"
	MaxWidth="610"
    MaxHeight="590"
	WindowStartupLocation="CenterScreen"
    Background="#F3F4F6"
    FontFamily="Segoe UI">

    <Window.Resources>

        <Style x:Key="CardStyle" TargetType="Border">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="CornerRadius" Value="7"/>
            <Setter Property="Padding" Value="9"/>
            <Setter Property="Margin" Value="3"/>
            <Setter Property="BorderBrush" Value="#E5E7EB"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

        <Style x:Key="TitleStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="10"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#6B7280"/>
            <Setter Property="Margin" Value="0,0,0,5"/>
        </Style>

        <Style x:Key="ValueStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="11"/>
            <Setter Property="Foreground" Value="#111827"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
            <Setter Property="Margin" Value="0,2,0,2"/>
        </Style>

        <Style x:Key="DetailStyle" TargetType="TextBlock">
            <Setter Property="FontSize" Value="9"/>
            <Setter Property="Foreground" Value="#6B7280"/>
            <Setter Property="Margin" Value="0,2,0,0"/>
            <Setter Property="TextWrapping" Value="Wrap"/>
        </Style>

    </Window.Resources>

    <Grid Margin="7">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="6"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="6"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- CABECALHO -->
        <Border Grid.Row="0"
                Background="#1F2937"
                CornerRadius="7"
                Padding="8">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="145"/>
                    <ColumnDefinition Width="75"/>
                    <ColumnDefinition Width="55"/>
                </Grid.ColumnDefinitions>

                <StackPanel Grid.Column="0" VerticalAlignment="Center">
                    <TextBlock Text="INFO COMPUTADORES"
                               Foreground="White"
                               FontSize="14"
                               FontWeight="Bold"/>
                    <TextBlock Text="Inventario de hardware"
                               Foreground="#D1D5DB"
                               FontSize="9"
                               Margin="0,2,0,0"/>
                </StackPanel>

                <TextBox x:Name="TxtHost"
                         Grid.Column="1"
                         Height="29"
                         Margin="4,0"
                         VerticalContentAlignment="Center"
                         Padding="5"
                         FontSize="11"
                         ToolTip="Digite o nome ou IP da maquina"/>

                <Button x:Name="BtnConsultar"
                        Grid.Column="2"
                        Height="29"
                        Margin="2,0"
                        Content="Consultar"
                        FontSize="10"
                        FontWeight="Bold"
                        Background="#2563EB"
                        Foreground="White"
                        BorderThickness="0"
                        Cursor="Hand"/>

                <Button x:Name="BtnLimpar"
                        Grid.Column="3"
                        Height="29"
                        Margin="2,0"
                        Content="Limpar"
                        FontSize="10"
                        Background="#374151"
                        Foreground="White"
                        BorderThickness="0"
                        Cursor="Hand"/>
            </Grid>
        </Border>

        <!-- RESULTADOS -->
        <Border Grid.Row="2"
                Background="#E5E7EB"
                CornerRadius="7"
                Padding="3">
            <ScrollViewer VerticalScrollBarVisibility="Auto"
                          HorizontalScrollBarVisibility="Disabled">
                <StackPanel>

                    <!-- IDENTIFICACAO -->
                    <Border Style="{StaticResource CardStyle}">
                        <Grid>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>

                            <StackPanel Grid.Column="0">
                                <TextBlock Text="COMPUTADOR"
                                           Style="{StaticResource TitleStyle}"/>
                                <TextBlock x:Name="TxtNomeComputador"
                                           Text="Aguardando consulta..."
                                           FontSize="15"
                                           FontWeight="Bold"
                                           Foreground="#111827"
                                           TextTrimming="CharacterEllipsis"/>
                                <TextBlock x:Name="TxtDataConsulta"
                                           Text="Data: --"
                                           Style="{StaticResource DetailStyle}"/>
                            </StackPanel>

                            <Border Grid.Column="1"
                                    Background="#F3F4F6"
                                    CornerRadius="6"
                                    Padding="7"
                                    VerticalAlignment="Center">
                                <StackPanel Orientation="Horizontal">
                                    <Ellipse x:Name="LedStatus"
                                             Width="8"
                                             Height="8"
                                             Fill="#9CA3AF"
                                             Margin="0,0,5,0"/>
                                    <TextBlock x:Name="TxtConectividade"
                                               Text="Aguardando"
                                               FontSize="10"
                                               FontWeight="SemiBold"
                                               Foreground="#6B7280"/>
                                </StackPanel>
                            </Border>
                        </Grid>
                    </Border>

                    <!-- CPU E RAM -->
                    <Grid>
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>

                        <Border Grid.Column="0" Style="{StaticResource CardStyle}">
                            <StackPanel>
                                <TextBlock Text="PROCESSADOR"
                                           Style="{StaticResource TitleStyle}"/>
                                <TextBlock x:Name="TxtCPU"
                                           Text="--"
                                           FontSize="12"
                                           FontWeight="Bold"
                                           Foreground="#111827"
                                           TextWrapping="Wrap"
                                           MaxHeight="42"
                                           Margin="0,2,0,5"/>
                                <Separator Margin="0,2,0,4"/>
                                <TextBlock x:Name="TxtCPUNucleos"
                                           Text="Nucleos: --"
                                           Style="{StaticResource ValueStyle}"/>
                                <TextBlock x:Name="TxtCPUThreads"
                                           Text="Threads: --"
                                           Style="{StaticResource ValueStyle}"/>
                                <TextBlock x:Name="TxtCPUClock"
                                           Text="Clock: --"
                                           Style="{StaticResource ValueStyle}"/>
                            </StackPanel>
                        </Border>

                        <Border Grid.Column="1" Style="{StaticResource CardStyle}">
                            <StackPanel>
                                <TextBlock Text="MEMORIA RAM"
                                           Style="{StaticResource TitleStyle}"/>
                                <TextBlock x:Name="TxtRAM"
                                           Text="-- GB"
                                           FontSize="25"
                                           FontWeight="Bold"
                                           Foreground="#2563EB"
                                           Margin="0,2,0,2"/>
                                <TextBlock Text="Memoria fisica total"
                                           FontSize="9"
                                           Foreground="#6B7280"/>
                                <Separator Margin="0,8,0,5"/>
                                <TextBlock x:Name="TxtRAMDetalhes"
                                           Text="Aguardando informacoes..."
                                           Style="{StaticResource ValueStyle}"/>
                            </StackPanel>
                        </Border>
                    </Grid>

                    <!-- PLACA-MAE -->
                    <Border Style="{StaticResource CardStyle}">
                        <StackPanel>
                            <TextBlock Text="PLACA-MAE"
                                       Style="{StaticResource TitleStyle}"/>
                            <TextBlock x:Name="TxtBoardFabricante"
                                       Text="Fabricante: --"
                                       Style="{StaticResource ValueStyle}"/>
                            <TextBlock x:Name="TxtBoardModelo"
                                       Text="Modelo: --"
                                       Style="{StaticResource ValueStyle}"/>
                            <TextBlock x:Name="TxtBoardSerial"
                                       Text="Numero de serie: --"
                                       Style="{StaticResource DetailStyle}"/>
                        </StackPanel>
                    </Border>

                    <!-- ARMAZENAMENTO -->
                    <Border Style="{StaticResource CardStyle}">
                        <StackPanel>
                            <TextBlock Text="ARMAZENAMENTO"
                                       Style="{StaticResource TitleStyle}"/>
                            <TextBlock x:Name="TxtTotalDiscos"
                                       Text="Unidades encontradas: 0"
                                       Style="{StaticResource DetailStyle}"
                                       Margin="0,0,0,6"/>
                            <StackPanel x:Name="PanelDiscos"/>
                        </StackPanel>
                    </Border>

                    <!-- ERROS -->
                    <Border x:Name="CardErro"
                            Background="#FEF2F2"
                            BorderBrush="#FECACA"
                            BorderThickness="1"
                            CornerRadius="7"
                            Padding="9"
                            Margin="3"
                            Visibility="Collapsed">
                        <StackPanel>
                            <TextBlock Text="ERRO NA CONSULTA"
                                       FontWeight="Bold"
                                       Foreground="#DC2626"
                                       FontSize="11"/>
                            <TextBlock x:Name="TxtErro"
                                       Text=""
                                       Foreground="#991B1B"
                                       FontSize="10"
                                       TextWrapping="Wrap"
                                       Margin="0,5,0,0"/>
                        </StackPanel>
                    </Border>

                </StackPanel>
            </ScrollViewer>
        </Border>

        <!-- STATUS -->
        <Border Grid.Row="4"
                Background="#FFFFFF"
                CornerRadius="5"
                Padding="6">
            <DockPanel>
                <StackPanel Orientation="Horizontal" DockPanel.Dock="Left">
                    <TextBlock Text="STATUS:"
                               FontWeight="Bold"
                               Foreground="#374151"
                               FontSize="9"/>
                    <TextBlock x:Name="TxtStatus"
                               Text="Aguardando consulta..."
                               Margin="5,0,0,0"
                               Foreground="#6B7280"
                               FontSize="9"/>
                </StackPanel>
                <TextBlock Text="Desenv. Guilherme Augusto | V2.2"
                           Foreground="#9CA3AF"
                           FontSize="9"
                           HorizontalAlignment="Right"
                           DockPanel.Dock="Right"/>
            </DockPanel>
        </Border>
    </Grid>
</Window>
"@
# ============================================================
# CARREGAMENTO DOS CONTROLES
# ============================================================
$Reader = New-Object System.Xml.XmlNodeReader $Xaml
$Window = [Windows.Markup.XamlReader]::Load($Reader)
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
# TESTAR EXISTENCIA DO COMPUTADOR
# ============================================================
function Test-ComputerExists {
    param([string]$ComputerName)
    try {
        $Result = Resolve-DnsName -Name $ComputerName -Type A -ErrorAction Stop
        return ($null -ne $Result)
    }
    catch {
        return $false
    }
}
# ============================================================
# RESOLVER NOME DO COMPUTADOR/IP
# ============================================================
function Resolve-ComputerTarget {
    param([string]$InputName)
    $InputName = $InputName.Trim()
    # IP informado: utiliza diretamente
    if ($InputName -match '^\d{1,3}(\.\d{1,3}){3}$') {
        return $InputName
    }
    # Somente numeros: procura os dois padroes
    if ($InputName -match '^\d+$') {
        $Computer1 = "fhsfa$InputName"
        $Computer2 = "fhsfasl$InputName"
        $Exists1 = Test-ComputerExists $Computer1
        $Exists2 = Test-ComputerExists $Computer2
        if ($Exists1 -and $Exists2) {
            $Choice = [System.Windows.MessageBox]::Show(
                "Foram encontrados dois computadores:`n`n" +
                "SIM = $Computer1`n" +
                "NAO = $Computer2`n`n" +
                "Deseja consultar $Computer1?",
                "Selecionar computador",
                [System.Windows.MessageBoxButton]::YesNoCancel,
                [System.Windows.MessageBoxImage]::Question
            )
            switch ($Choice) {
                "Yes" { return $Computer1 }
                "No"  { return $Computer2 }
                default { return $null }
            }
        }
        if ($Exists1) { return $Computer1 }
        if ($Exists2) { return $Computer2 }
        return $null
    }
    # Nome completo informado
    return $InputName
}
# ============================================================
# ADICIONAR CARTAO DE DISCO
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
    $Card.CornerRadius = New-Object System.Windows.CornerRadius(6)
    $Card.Padding = New-Object System.Windows.Thickness(7)
    $Card.Margin = New-Object System.Windows.Thickness(0,0,0,5)
    $Stack = New-Object System.Windows.Controls.StackPanel
    $Title = New-Object System.Windows.Controls.TextBlock
    $Title.Text = "$Type - $Size GB"
    $Title.FontSize = 11
    $Title.FontWeight = "Bold"
    $Title.Foreground = [System.Windows.Media.Brushes]::DarkSlateBlue
    $Stack.Children.Add($Title) | Out-Null
    $ModelText = New-Object System.Windows.Controls.TextBlock
    $ModelText.Text = "Modelo: $Model"
    $ModelText.FontSize = 10
    $ModelText.Foreground = [System.Windows.Media.Brushes]::Black
    $ModelText.TextWrapping = "Wrap"
    $ModelText.Margin = New-Object System.Windows.Thickness(0,4,0,2)
    $Stack.Children.Add($ModelText) | Out-Null
    $SerialText = New-Object System.Windows.Controls.TextBlock
    $SerialText.Text = "Serial: $Serial"
    $SerialText.FontSize = 9
    $SerialText.Foreground = [System.Windows.Media.Brushes]::Gray
    $SerialText.TextWrapping = "Wrap"
    $Stack.Children.Add($SerialText) | Out-Null
    $Card.Child = $Stack
    $PanelDiscos.Children.Add($Card) | Out-Null
}
# ============================================================
# LIMPAR RESULTADOS
# ============================================================
function Clear-HardwareInfo {
    $TxtNomeComputador.Text = "Aguardando consulta..."
    $TxtDataConsulta.Text = "Data: --"
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
    $TxtErro.Text = ""
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
        # CONECTIVIDADE
        $Ping = Test-Connection -ComputerName $Target -Count 1 -Quiet -ErrorAction SilentlyContinue

        if (-not $Ping) {
            $LedStatus.Fill = [System.Windows.Media.Brushes]::Red
            $TxtConectividade.Text = "Inacessivel"
            $TxtStatus.Text = "Computador inacessivel."
            $TxtStatus.Foreground = "#DC2626"
            return
        }
        $LedStatus.Fill = [System.Windows.Media.Brushes]::Green
        $TxtConectividade.Text = "Online"
        $TxtDataConsulta.Text = "Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
        # PROCESSADOR
        $CPU = Get-WmiObject -Class Win32_Processor -ComputerName $Target -ErrorAction Stop
        $Processor = $CPU | Select-Object -First 1
        $TxtCPU.Text = ([string]$Processor.Name).Trim()
        $TxtCPUNucleos.Text = "Nucleos: $($Processor.NumberOfCores)"
        $TxtCPUThreads.Text = "Threads: $($Processor.NumberOfLogicalProcessors)"
        $Clock = [math]::Round($Processor.MaxClockSpeed / 1000, 2)
        $TxtCPUClock.Text = "Clock maximo: $Clock GHz"
        # MEMORIA RAM
        $Computer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Target -ErrorAction Stop
        $RAMGB = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
        $TxtRAM.Text = "$RAMGB GB"
        $TxtRAMDetalhes.Text = "Memoria fisica total instalada"
        # PLACA-MAE
        $Board = Get-WmiObject -Class Win32_BaseBoard -ComputerName $Target -ErrorAction Stop
        $Item = $Board | Select-Object -First 1
        $TxtBoardFabricante.Text = "Fabricante: $($Item.Manufacturer)"
        $TxtBoardModelo.Text = "Modelo: $($Item.Product)"
        $TxtBoardSerial.Text = "Numero de serie: $($Item.SerialNumber)"
        # ARMAZENAMENTO
        $Disks = @(Get-WmiObject -Class Win32_DiskDrive -ComputerName $Target -ErrorAction Stop)
        $PanelDiscos.Children.Clear()
        $TxtTotalDiscos.Text = "Unidades encontradas: $($Disks.Count)"
        foreach ($Disk in $Disks) {
            if ($Disk.Size) {
                $SizeGB = [math]::Round($Disk.Size / 1GB, 2)
            }
            else {
                $SizeGB = 0
            }

            # Win32_DiskDrive nem sempre identifica o tipo de midia.
            # O nome do modelo e usado como indicio, nao como garantia.
            $Model = [string]$Disk.Model
            $MediaType = [string]$Disk.MediaType

            if ($Model -match 'SSD|NVMe' -or $MediaType -match 'SSD') {
                $Type = "SSD"
            }
            elseif ($MediaType -match 'Fixed hard disk') {
                $Type = "HD / HDD"
            }
            else {
                $Type = "Disco - tipo nao identificado"
            }

            Add-DiskCard `
                -Model $Model `
                -Type $Type `
                -Size $SizeGB `
                -Serial ([string]$Disk.SerialNumber)
        }
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
# BOTOES\EVENTOS
# ============================================================
$BtnConsultar.Add_Click({
    Get-HardwareInfo
})
$TxtHost.Add_KeyDown({
    param($Sender, $EventArgs)
    if ($EventArgs.Key -eq "Return") {
        Get-HardwareInfo
    }
})
$BtnLimpar.Add_Click({
    Clear-HardwareInfo
    $TxtHost.Clear()
    $TxtStatus.Text = "Aguardando consulta..."
    $TxtStatus.Foreground = "#6B7280"
    $TxtHost.Focus()
})
$Window.Add_ContentRendered({
    $TxtHost.Focus() | Out-Null
})
# ============================================================
# INICIAR
# ============================================================
$null = $Window.ShowDialog()
