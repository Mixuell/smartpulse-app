import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(SmartPulseApp());
}

class SmartPulseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2E7D32),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2E7D32),
          primary: Color(0xFF2E7D32),
          secondary: Color(0xFF4CAF50),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

// ============================================
// PANTALLA 1: LOGIN
// ============================================

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  final String _correctUsername = "maria";
  final String _correctPassword = "smartpulse123";

  void _login() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (username.isEmpty || password.isEmpty || name.isEmpty) {
      _showError("Por favor completa todos los campos");
      return;
    }

    if (username != _correctUsername || password != _correctPassword) {
      _showError("Usuario o contraseña incorrectos");
      return;
    }

    _saveName(name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(userName: name)),
    );
  }

  Future<void> _saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFD32F2F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B5E20),
              Color(0xFF2E7D32),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.vibration,
                            size: 60,
                            color: Color(0xFF2E7D32),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'SmartPulse',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Inclusión Laboral Inteligente',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 48),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Tu nombre',
                              prefixIcon: Icon(Icons.badge),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Ejemplo: María',
                            ),
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              child: Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Usuario: maria | Contraseña: smartpulse123',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// PANTALLA 2: PRINCIPAL
// ============================================

class MainScreen extends StatefulWidget {
  final String userName;

  MainScreen({required this.userName});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isConnected = false;
  List<String> alertHistory = [];
  BluetoothDevice? smartPulseDevice;
  BluetoothCharacteristic? commandChar;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Future<void> _connectBluetooth() async {
    try {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult r in results) {
          if (r.device.platformName.contains("SmartPulse") ||
              r.device.platformName.contains("ESP32")) {
            smartPulseDevice = r.device;
            FlutterBluePlus.stopScan();
            await _connectToDevice();
            break;
          }
        }
      });
    } catch (e) {
      _showMessage("Error al buscar dispositivos: $e");
    }
  }

  Future<void> _connectToDevice() async {
    if (smartPulseDevice == null) return;

    try {
      await smartPulseDevice!.connect();
      List<BluetoothService> services =
          await smartPulseDevice!.discoverServices();

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.properties.write) {
            commandChar = c;
            setState(() {
              isConnected = true;
            });
            _showMessage("Conectado a SmartPulse");
            return;
          }
        }
      }
    } catch (e) {
      _showMessage("Error al conectar: $e");
    }
  }

  Future<void> _sendAlert() async {
    if (!isConnected || commandChar == null) {
      _showMessage("Por favor conecta el dispositivo primero");
      return;
    }

    try {
      await commandChar!.write("VIBRAR".codeUnits);

      String time =
          "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";
      setState(() {
        alertHistory.insert(0, "$time - Alerta enviada");
      });

      _showMessage("¡Alerta enviada al ESP32!");
    } catch (e) {
      _showMessage("Error al enviar alerta: $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _logout() {
    smartPulseDevice?.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SmartPulse'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Color(0xFF2E7D32),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, ${widget.userName}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Bienvenido a SmartPulse',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(
                  isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: isConnected ? Color(0xFF2E7D32) : Color(0xFFD32F2F),
                  size: 40,
                ),
                title: Text(
                  isConnected ? 'Conectado a SmartPulse' : 'Desconectado',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isConnected ? 'Listo para alertas' : 'Presiona para conectar',
                ),
                trailing: isConnected
                    ? Icon(Icons.check_circle, color: Color(0xFF2E7D32))
                    : ElevatedButton(
                        onPressed: _connectBluetooth,
                        child: Text('Conectar'),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Color(0xFF2E7D32),
              elevation: 8,
              child: InkWell(
                onTap: _sendAlert,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: 80,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ENVIAR ALERTA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Presiona para activar vibración',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, color: Color(0xFF2E7D32)),
                        SizedBox(width: 8),
                        Text(
                          'Historial de alertas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if (alertHistory.isEmpty)
                      Text(
                        'Sin alertas aún',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      ...alertHistory.take(5).map((alert) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Color(0xFF4CAF50), size: 16),
                                SizedBox(width: 8),
                                Text(alert, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    smartPulseDevice?.disconnect();
    super.dispose();
  }
}
