import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BotanikApp());
}

class BotanikApp extends StatelessWidget {
  const BotanikApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanik Yönetim',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(
          0xFFFDFCF8,
        ), // Sıcak Krem Arka Plan
        fontFamily: 'sans-serif',
      ),
      home: const LoginGateScreen(),
    );
  }
}

class LoginGateScreen extends StatefulWidget {
  const LoginGateScreen({super.key});
  @override
  State<LoginGateScreen> createState() => _LoginGateScreenState();
}

class _LoginGateScreenState extends State<LoginGateScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = "5858"; // Aile giriş şifresi
  String _errorMessage = "";
  void _checkPin() {
    if (_pinController.text == _correctPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Hatalı şifre! Lütfen ailenize özel şifreyi girin.";
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2E1D), // Koyu Orman Yeşili
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_florist,
                size: 80,
                color: Color(0xFF8A9A5B),
              ),
              const SizedBox(height: 24),
              const Text(
                'BOTANİK AJANDA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aileye Özel Yönetim Sistemi',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 48),
              Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Giriş Şifresi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1B2E1D),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: '••••',
                        hintStyle: const TextStyle(letterSpacing: 2),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSubmitted: (_) => _checkPin(),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A703C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _checkPin,
                        child: const Text(
                          'GİRİŞ YAP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Project {
  String name;
  String status;
  double budget;
  String date;
  Project({
    required this.name,
    required this.status,
    required this.budget,
    required this.date,
  });
  Map<String, dynamic> toMap() => {
    'name': name,
    'status': status,
    'budget': budget,
    'date': date,
  };
  factory Project.fromMap(Map<String, dynamic> map) => Project(
    name: map['name'] ?? '',
    status: map['status'] ?? 'Devam Ediyor',
    budget: (map['budget'] ?? 0.0).toDouble(),
    date: map['date'] ?? '',
  );
}

class Expense {
  String title;
  double amount;
  String date;
  Expense({required this.title, required this.amount, required this.date});
  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
    'date': date,
  };
  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    title: map['title'] ?? '',
    amount: (map['amount'] ?? 0.0).toDouble(),
    date: map['date'] ?? '',
  );
}

class Plant {
  String name;
  int stock;
  double price;
  Plant({required this.name, required this.stock, required this.price});
  Map<String, dynamic> toMap() => {
    'name': name,
    'stock': stock,
    'price': price,
  };
  factory Plant.fromMap(Map<String, dynamic> map) => Plant(
    name: map['name'] ?? '',
    stock: map['stock'] ?? 0,
    price: (map['price'] ?? 0.0).toDouble(),
  );
}

class Worker {
  String name;
  double dailyWage;
  double totalWagesDue;
  Worker({
    required this.name,
    required this.dailyWage,
    this.totalWagesDue = 0.0,
  });
  Map<String, dynamic> toMap() => {
    'name': name,
    'dailyWage': dailyWage,
    'totalWagesDue': totalWagesDue,
  };
  factory Worker.fromMap(Map<String, dynamic> map) => Worker(
    name: map['name'] ?? '',
    dailyWage: (map['dailyWage'] ?? 0.0).toDouble(),
    totalWagesDue: (map['totalWagesDue'] ?? 0.0).toDouble(),
  );
}

class Sale {
  String plantName;
  int quantity;
  double totalAmount;
  String customerName;
  String date;
  Sale({
    required this.plantName,
    required this.quantity,
    required this.totalAmount,
    required this.customerName,
    required this.date,
  });
  Map<String, dynamic> toMap() => {
    'plantName': plantName,
    'quantity': quantity,
    'totalAmount': totalAmount,
    'customerName': customerName,
    'date': date,
  };
  factory Sale.fromMap(Map<String, dynamic> map) => Sale(
    plantName: map['plantName'] ?? '',
    quantity: map['quantity'] ?? 0,
    totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
    customerName: map['customerName'] ?? '',
    date: map['date'] ?? '',
  );
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 1; // Mali Hesaplar sekmesiyle başla
  bool _isLoading = true;
  List<Project> projects = [];
  List<Expense> expenses = [];
  List<Plant> plants = [];
  List<Worker> workers = [];
  List<Sale> sales = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Projeler
      final projString = prefs.getString('projects');
      if (projString != null) {
        final List decoded = jsonDecode(projString);
        projects = decoded
            .map<Project>((item) => Project.fromMap(item))
            .toList();
      } else {
        projects = [
          Project(
            name: 'Sarıyer Villa Bahçesi',
            status: 'Devam Ediyor',
            budget: 80000.0,
            date: '4 Temmuz 2026',
          ),
          Project(
            name: 'Etiler Botanik Park',
            status: 'Tamamlandı',
            budget: 30000.0,
            date: '2 Temmuz 2026',
          ),
        ];
      }
      // Giderler
      final expString = prefs.getString('expenses');
      if (expString != null) {
        final List decoded = jsonDecode(expString);
        expenses = decoded
            .map<Expense>((item) => Expense.fromMap(item))
            .toList();
      } else {
        expenses = [
          Expense(
            title: 'Bitki Alımı Faturası',
            amount: 4500.0,
            date: '4 Temmuz 2026',
          ),
        ];
      }
      // Bitki Stokları
      final plantString = prefs.getString('plants');
      if (plantString != null) {
        final List decoded = jsonDecode(plantString);
        plants = decoded.map<Plant>((item) => Plant.fromMap(item)).toList();
      } else {
        plants = [
          Plant(name: 'Limon Servi', stock: 45, price: 350.0),
          Plant(name: 'Rulo Çim (m²)', stock: 1200, price: 120.0),
          Plant(name: 'Zeytin Ağacı (Yaşlı)', stock: 8, price: 7500.0),
        ];
      }
      // İşçiler
      final workerString = prefs.getString('workers');
      if (workerString != null) {
        final List decoded = jsonDecode(workerString);
        workers = decoded.map<Worker>((item) => Worker.fromMap(item)).toList();
      } else {
        workers = [
          Worker(
            name: 'Ahmet Usta (Peyzaj)',
            dailyWage: 1500.0,
            totalWagesDue: 4500.0,
          ),
          Worker(
            name: 'Mehmet Can (Yevmiyeli)',
            dailyWage: 1200.0,
            totalWagesDue: 2400.0,
          ),
        ];
      }
      // Satışlar
      final saleString = prefs.getString('sales');
      if (saleString != null) {
        final List decoded = jsonDecode(saleString);
        sales = decoded.map<Sale>((item) => Sale.fromMap(item)).toList();
      } else {
        sales = [];
      }
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'projects',
      jsonEncode(projects.map((e) => e.toMap()).toList()),
    );
    await prefs.setString(
      'expenses',
      jsonEncode(expenses.map((e) => e.toMap()).toList()),
    );
    await prefs.setString(
      'plants',
      jsonEncode(plants.map((e) => e.toMap()).toList()),
    );
    await prefs.setString(
      'workers',
      jsonEncode(workers.map((e) => e.toMap()).toList()),
    );
    await prefs.setString(
      'sales',
      jsonEncode(sales.map((e) => e.toMap()).toList()),
    );
  }

  double get totalRevenue {
    double projectTotal = projects.fold(0.0, (sum, item) => sum + item.budget);
    double salesTotal = sales.fold(0.0, (sum, item) => sum + item.totalAmount);
    return projectTotal + salesTotal;
  }

  double get totalExpenses {
    double directExpenses = expenses.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
    double workerExpenses = workers.fold(
      0.0,
      (sum, item) => sum + item.totalWagesDue,
    );
    return directExpenses + workerExpenses;
  }

  Future<String> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A703C),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1B2E1D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final months = [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
      return "${picked.day} ${months[picked.month - 1]} ${picked.year}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4A703C)),
        ),
      );
    }
    final List<Widget> screens = [
      _buildAjandaTab(),
      _buildMaliTab(),
      _buildBotanikTab(),
      _buildIscilerTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8A9A5B), // Adaçayı Yeşili
        elevation: 0,
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1B2E1D), // Koyu Orman Yeşili
        unselectedItemColor: Colors.grey[400],
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, size: 26),
            label: 'Ajanda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 26),
            label: 'Mali Hesap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist, size: 26),
            label: 'Satış/Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 26),
            label: 'İşçiler',
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'İŞ AJANDASI';
      case 1:
        return 'MALİ DURUM PANELİ';
      case 2:
        return 'BOTANİK SATIŞ & STOK';
      case 3:
        return 'EKİP & YEVMİYE HESABI';
      default:
        return 'BOTANİK AJANDA';
    }
  }

  Widget _buildAjandaTab() {
    if (projects.isEmpty) {
      return const Center(child: Text('Kayıtlı aktif iş bulunamadı.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final proj = projects[index];
        return Card(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: proj.status == 'Devam Ediyor'
                  ? Colors.orange[50]
                  : Colors.green[50],
              child: Icon(
                proj.status == 'Devam Ediyor'
                    ? Icons.engineering
                    : Icons.check_circle,
                color: proj.status == 'Devam Ediyor'
                    ? Colors.orange[800]
                    : Colors.green[800],
              ),
            ),
            title: Text(
              proj.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text(
                  'Tarih: ${proj.date}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Durum: ${proj.status}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: proj.status == 'Devam Ediyor'
                        ? Colors.orange[800]
                        : Colors.green[800],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (val) {
                setState(() {
                  if (val == 'tamamla') {
                    proj.status = 'Tamamlandı';
                  } else if (val == 'sil') {
                    projects.removeAt(index);
                  }
                  _saveData();
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'tamamla',
                  child: Text('Tamamlandı Yap'),
                ),
                const PopupMenuItem(
                  value: 'sil',
                  child: Text(
                    'Projeyi Sil',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMaliTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOzetKarti(
                  'TOPLAM GELİR',
                  '₺${totalRevenue.toStringAsFixed(0)}',
                  Colors.green[700]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOzetKarti(
                  'TOPLAM GİDER',
                  '₺${totalExpenses.toStringAsFixed(0)}',
                  Colors.red[700]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2E1D),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NET KASA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₺${(totalRevenue - totalExpenses).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: (totalRevenue - totalExpenses) >= 0
                        ? Colors.green[300]
                        : Colors.red[300],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A703C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showAddProjectDialog(),
                  icon: const Icon(Icons.add_business, color: Colors.white),
                  label: const Text(
                    'Proje Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _showAddExpenseDialog(),
                  icon: const Icon(Icons.money_off, color: Colors.white),
                  label: const Text(
                    'Gider Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'PROJELER VE ALINAN HAKEDİŞLER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E1D),
            ),
          ),
          const SizedBox(height: 10),
          ...projects.map((proj) => _buildProjeItem(proj)),
          const SizedBox(height: 20),
          const Text(
            'GENEL GİDERLER',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E1D),
            ),
          ),
          const SizedBox(height: 10),
          if (expenses.isEmpty)
            const Text(
              'Kayıtlı gider bulunmamaktadır.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            )
          else
            ...expenses.map((exp) => _buildGiderItem(exp)),
        ],
      ),
    );
  }

  Widget _buildBotanikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'STOKTAKİ BİTKİLER',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1D),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddPlantDialog(),
                icon: const Icon(Icons.add, color: Color(0xFF4A703C)),
                label: const Text(
                  'Yeni Bitki',
                  style: TextStyle(
                    color: Color(0xFF4A703C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    plant.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Adet: ${plant.stock}   |   Birim: ₺${plant.price.toStringAsFixed(0)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () => _showEditPlantDialog(plant, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            plants.removeAt(index);
                            _saveData();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EAD7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shopping_basket, color: Color(0xFF1B2E1D)),
                    SizedBox(width: 8),
                    Text(
                      'YENİ SATIŞ KAYDI YAP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2E1D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Satılan bitkileri doğrudan kasaya gelir olarak işlemek ve stoktan düşmek için burayı kullanın.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B2E1D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showAddSaleDialog(),
                    child: const Text(
                      'SATIŞ GİRİŞİ YAP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'SATIŞ GEÇMİŞİ & FATURALAR',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E1D),
            ),
          ),
          const SizedBox(height: 10),
          if (sales.isEmpty)
            const Text(
              'Henüz satış kaydı girilmedi.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            )
          else
            ...sales.reversed.map((sale) => _buildSaleLogItem(sale)),
        ],
      ),
    );
  }

  Widget _buildIscilerTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EKİP LİSTESİ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2E1D),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A703C),
                ),
                onPressed: () => _showAddWorkerDialog(),
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Yeni İşçi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final worker = workers[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Yevmiye: ₺${worker.dailyWage.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Alacak: ₺${worker.totalWagesDue.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC19A6B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                worker.totalWagesDue += worker.dailyWage;
                                _saveData();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${worker.name} için 1 yevmiye yazıldı.',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                            label: const Text(
                              'Yevmiye',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () => _showPaymentDialog(worker, index),
                            child: const Text(
                              'Ödeme Yap',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOzetKarti(String baslik, String miktar, Color renk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAD7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            baslik,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: renk,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            miktar,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: renk,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjeItem(Project proj) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAD7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proj.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                proj.status,
                style: TextStyle(
                  color: proj.status == 'Devam Ediyor'
                      ? Colors.orange[800]
                      : Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            '+ ₺${proj.budget.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiderItem(Expense exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5EAD7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exp.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                exp.date,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          Text(
            '- ₺${exp.amount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleLogItem(Sale sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2EBE2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sale.quantity} Adet ${sale.plantName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Alıcı: ${sale.customerName.isEmpty ? "Belirtilmedi" : sale.customerName}',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              Text(
                sale.date,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          Text(
            '+ ₺${sale.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog() {
    final nameController = TextEditingController();
    final budgetController = TextEditingController();
    String selectedDateStr = "Tarih Seçilmedi";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Yeni Proje Ekle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Proje / Müşteri Adı',
                    ),
                  ),
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Anlaşılan Bütçe (₺)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDateStr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A9A5B),
                        ),
                        onPressed: () async {
                          String date = await _selectDate(context);
                          if (date.isNotEmpty) {
                            setModalState(() => selectedDateStr = date);
                          }
                        },
                        child: const Text(
                          'Tarih Seç',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2E1D),
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        budgetController.text.isNotEmpty &&
                        selectedDateStr != "Tarih Seçilmedi") {
                      setState(() {
                        projects.add(
                          Project(
                            name: nameController.text,
                            status: 'Devam Ediyor',
                            budget:
                                double.tryParse(budgetController.text) ?? 0.0,
                            date: selectedDateStr,
                          ),
                        );
                        _saveData();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedDateStr = "Tarih Seçilmedi";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Yeni Gider Girişi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Harcama Nedeni (Örn: Gübre, Benzin)',
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tutar (₺)'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDateStr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A9A5B),
                        ),
                        onPressed: () async {
                          String date = await _selectDate(context);
                          if (date.isNotEmpty) {
                            setModalState(() => selectedDateStr = date);
                          }
                        },
                        child: const Text(
                          'Tarih Seç',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2E1D),
                  ),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedDateStr != "Tarih Seçilmedi") {
                      setState(() {
                        expenses.add(
                          Expense(
                            title: titleController.text,
                            amount:
                                double.tryParse(amountController.text) ?? 0.0,
                            date: selectedDateStr,
                          ),
                        );
                        _saveData();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPlantDialog() {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final priceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Yeni Bitki Türü Tanımla'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Bitki Adı (Örn: Limon Servi)',
                ),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Başlangıç Stoğu (Adet)',
                ),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Birim Satış Fiyatı (₺)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2E1D),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    stockController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    plants.add(
                      Plant(
                        name: nameController.text,
                        stock: int.tryParse(stockController.text) ?? 0,
                        price: double.tryParse(priceController.text) ?? 0.0,
                      ),
                    );
                    _saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showEditPlantDialog(Plant plant, int index) {
    final nameController = TextEditingController(text: plant.name);
    final stockController = TextEditingController(text: plant.stock.toString());
    final priceController = TextEditingController(
      text: plant.price.toStringAsFixed(0),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Bitki Bilgilerini Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Bitki Adı'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok Adedi'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Birim Fiyatı (₺)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2E1D),
              ),
              onPressed: () {
                setState(() {
                  plant.name = nameController.text;
                  plant.stock =
                      int.tryParse(stockController.text) ?? plant.stock;
                  plant.price =
                      double.tryParse(priceController.text) ?? plant.price;
                  _saveData();
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Güncelle',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddSaleDialog() {
    if (plants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Önce stok bölümünden satılacak bir bitki tanımlamalısınız!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Plant selectedPlant = plants[0];
    final quantityController = TextEditingController(text: "1");
    final customerController = TextEditingController();
    final priceController = TextEditingController(
      text: selectedPlant.price.toStringAsFixed(0),
    );
    String selectedDateStr = "Tarih Seçilmedi";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Yeni Satış Kaydı'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<Plant>(
                      isExpanded: true,
                      value: selectedPlant,
                      items: plants.map((Plant value) {
                        return DropdownMenuItem<Plant>(
                          value: value,
                          child: Text('${value.name} (Stok: ${value.stock})'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setModalState(() {
                            selectedPlant = newValue;
                            priceController.text = newValue.price
                                .toStringAsFixed(0);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Satış Adedi',
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Birim Fiyatı (₺)',
                      ),
                    ),
                    TextField(
                      controller: customerController,
                      decoration: const InputDecoration(
                        labelText: 'Alıcı Adı / Müşteri',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDateStr,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A9A5B),
                          ),
                          onPressed: () async {
                            String date = await _selectDate(context);
                            if (date.isNotEmpty) {
                              setModalState(() => selectedDateStr = date);
                            }
                          },
                          child: const Text(
                            'Tarih Seç',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2E1D),
                  ),
                  onPressed: () {
                    final int qty = int.tryParse(quantityController.text) ?? 1;
                    final double customPrice =
                        double.tryParse(priceController.text) ??
                        selectedPlant.price;
                    if (selectedPlant.stock >= qty) {
                      setState(() {
                        selectedPlant.stock -= qty;
                        sales.add(
                          Sale(
                            plantName: selectedPlant.name,
                            quantity: qty,
                            totalAmount: customPrice * qty,
                            customerName: customerController.text,
                            date: selectedDateStr == "Tarih Seçilmedi"
                                ? "Bugün"
                                : selectedDateStr,
                          ),
                        );
                        _saveData();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Satış başarıyla kaydedildi!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Hata: Stokta yeterli bitki yok!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Tamamla',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddWorkerDialog() {
    final nameController = TextEditingController();
    final wageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Yeni İşçi Kaydı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Adı Soyadı'),
              ),
              TextField(
                controller: wageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Günlük Yevmiye (₺)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2E1D),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    wageController.text.isNotEmpty) {
                  setState(() {
                    workers.add(
                      Worker(
                        name: nameController.text,
                        dailyWage: double.tryParse(wageController.text) ?? 0.0,
                      ),
                    );
                    _saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Kaydet',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDialog(Worker worker, int index) {
    final paymentController = TextEditingController();
    String selectedDateStr = "Tarih Seçilmedi";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('${worker.name} Ödemesi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kalan Alacak: ₺${worker.totalWagesDue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: paymentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Ödenen Tutar (₺)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDateStr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8A9A5B),
                        ),
                        onPressed: () async {
                          String date = await _selectDate(context);
                          if (date.isNotEmpty) {
                            setModalState(() => selectedDateStr = date);
                          }
                        },
                        child: const Text(
                          'Tarih Seç',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2E1D),
                  ),
                  onPressed: () {
                    final double pay =
                        double.tryParse(paymentController.text) ?? 0.0;
                    if (pay > 0 && selectedDateStr != "Tarih Seçilmedi") {
                      setState(() {
                        worker.totalWagesDue -= pay;
                        if (worker.totalWagesDue < 0) worker.totalWagesDue = 0;
                        expenses.add(
                          Expense(
                            title: '${worker.name} Ödemesi',
                            amount: pay,
                            date: selectedDateStr,
                          ),
                        );
                        _saveData();
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Öde',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
