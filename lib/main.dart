import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBakCQGI2u5W1R6Yoo8YkY2gM3d0Uq7fuM",
      authDomain: "botanikajanda.firebaseapp.com",
      projectId: "botanikajanda",
      storageBucket: "botanikajanda.firebasestorage.app",
      messagingSenderId: "982110387949",
      appId: "1:982110387949:web:1a785db66c00173b0f96e4",
    ),
  );

  // Firebase offline desteğini aktif et
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

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
        scaffoldBackgroundColor: const Color(0xFFFDFCF8),
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
  final String _correctPin = "5858";
  String _errorMessage = "";

  void _checkPin() {
    if (_pinController.text == _correctPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Hatalı şifre!";
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2E1D),
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

// MODELLER (Firebase ID'leri eklendi ve Expense'e category eklendi)
class Project {
  String? id;
  String name;
  String status;
  double budget;
  String date;
  Project({
    this.id,
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
  factory Project.fromMap(String id, Map<String, dynamic> map) => Project(
    id: id,
    name: map['name'] ?? '',
    status: map['status'] ?? 'Devam Ediyor',
    budget: (map['budget'] ?? 0.0).toDouble(),
    date: map['date'] ?? '',
  );
}

class Expense {
  String? id;
  String title;
  double amount;
  String date;
  String category;
  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category = 'Genel',
  });
  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
    'date': date,
    'category': category,
  };
  factory Expense.fromMap(String id, Map<String, dynamic> map) => Expense(
    id: id,
    title: map['title'] ?? '',
    amount: (map['amount'] ?? 0.0).toDouble(),
    date: map['date'] ?? '',
    category: map['category'] ?? 'Genel',
  );
}

class Plant {
  String? id;
  String name;
  int stock;
  double price;
  Plant({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
  });
  Map<String, dynamic> toMap() => {
    'name': name,
    'stock': stock,
    'price': price,
  };
  factory Plant.fromMap(String id, Map<String, dynamic> map) => Plant(
    id: id,
    name: map['name'] ?? '',
    stock: map['stock'] ?? 0,
    price: (map['price'] ?? 0.0).toDouble(),
  );
}

class Worker {
  String? id;
  String name;
  double dailyWage;
  double totalWagesDue;
  Worker({
    this.id,
    required this.name,
    required this.dailyWage,
    this.totalWagesDue = 0.0,
  });
  Map<String, dynamic> toMap() => {
    'name': name,
    'dailyWage': dailyWage,
    'totalWagesDue': totalWagesDue,
  };
  factory Worker.fromMap(String id, Map<String, dynamic> map) => Worker(
    id: id,
    name: map['name'] ?? '',
    dailyWage: (map['dailyWage'] ?? 0.0).toDouble(),
    totalWagesDue: (map['totalWagesDue'] ?? 0.0).toDouble(),
  );
}

class Sale {
  String? id;
  String plantName;
  int quantity;
  double totalAmount;
  String customerName;
  String date;
  Sale({
    this.id,
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
  factory Sale.fromMap(String id, Map<String, dynamic> map) => Sale(
    id: id,
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
  int _currentIndex = 1;
  bool _isLoading = true;

  List<Project> projects = [];
  List<Expense> expenses = [];
  List<Plant> plants = [];
  List<Worker> workers = [];
  List<Sale> sales = [];
  List<String> expenseCategories = [
    'Gübre',
    'Tohum',
    'Maaş',
    'Lojistik',
    'Genel',
  ]; // Varsayılanlar

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadAllDataFromFirebase();
  }

  Future<void> _loadAllDataFromFirebase() async {
    setState(() => _isLoading = true);
    try {
      // Projeler
      final projSnap = await _db.collection('projects').get();
      projects = projSnap.docs
          .map((d) => Project.fromMap(d.id, d.data()))
          .toList();

      // Giderler
      final expSnap = await _db.collection('expenses').get();
      expenses = expSnap.docs
          .map((d) => Expense.fromMap(d.id, d.data()))
          .toList();

      // Bitkiler
      final plantSnap = await _db.collection('plants').get();
      plants = plantSnap.docs
          .map((d) => Plant.fromMap(d.id, d.data()))
          .toList();

      // İşçiler
      final workerSnap = await _db.collection('workers').get();
      workers = workerSnap.docs
          .map((d) => Worker.fromMap(d.id, d.data()))
          .toList();

      // Satışlar
      final saleSnap = await _db.collection('sales').get();
      sales = saleSnap.docs.map((d) => Sale.fromMap(d.id, d.data())).toList();

      // Kategoriler
      final catSnap = await _db.collection('settings').doc('categories').get();
      if (catSnap.exists && catSnap.data()!['expenseCategories'] != null) {
        expenseCategories = List<String>.from(
          catSnap.data()!['expenseCategories'],
        );
      } else {
        // İlk defa çalışıyorsa varsayılanları kaydet
        await _db.collection('settings').doc('categories').set({
          'expenseCategories': expenseCategories,
        });
      }
    } catch (e) {
      print("Firebase yükleme hatası: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double get totalRevenue =>
      projects.fold(0.0, (sum, item) => sum + item.budget) +
      sales.fold(0.0, (sum, item) => sum + item.totalAmount);
  double get totalExpenses =>
      expenses.fold(0.0, (sum, item) => sum + item.amount) +
      workers.fold(0.0, (sum, item) => sum + item.totalWagesDue);

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
    if (_isLoading)
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4A703C)),
        ),
      );

    final List<Widget> screens = [
      _buildAjandaTab(),
      _buildMaliTab(),
      _buildBotanikTab(),
      _buildIscilerTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8A9A5B),
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
        selectedItemColor: const Color(0xFF1B2E1D),
        unselectedItemColor: Colors.grey[400],
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) => setState(() => _currentIndex = index),
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
    if (projects.isEmpty)
      return const Center(child: Text('Kayıtlı aktif iş bulunamadı.'));
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
              onSelected: (val) async {
                if (val == 'tamamla') {
                  proj.status = 'Tamamlandı';
                  await _db.collection('projects').doc(proj.id).update({
                    'status': 'Tamamlandı',
                  });
                  setState(() {});
                } else if (val == 'duzenle') {
                  _showEditProjectDialog(proj, index);
                } else if (val == 'sil') {
                  await _db.collection('projects').doc(proj.id).delete();
                  setState(() => projects.removeAt(index));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'tamamla',
                  child: Text('Tamamlandı Yap'),
                ),
                const PopupMenuItem(value: 'duzenle', child: Text('Düzenle')),
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

  // --- BOTANİK, İŞÇİLER ve YARDIMCI WIDGET'LAR (Mevcut yapıyı korudum, sadece UI gösterimi) ---
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
                        onPressed: () async {
                          await _db.collection('plants').doc(plant.id).delete();
                          setState(() => plants.removeAt(index));
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final saleIndex = sales.length - 1 - index;
                return _buildSaleLogItem(sales[saleIndex], saleIndex);
              },
            ),
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
                            onPressed: () async {
                              worker.totalWagesDue += worker.dailyWage;
                              await _db
                                  .collection('workers')
                                  .doc(worker.id)
                                  .update({
                                    'totalWagesDue': worker.totalWagesDue,
                                  });
                              setState(() {});
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
                          Row(
                            children: [
                              TextButton(
                                onPressed: () =>
                                    _showPaymentDialog(worker, index),
                                child: const Text(
                                  'Ödeme Yap',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('İşçiyi Sil'),
                                      content: Text(
                                        '${worker.name} ekibinden silinsin mi?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Vazgeç'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () async {
                                            await _db
                                                .collection('workers')
                                                .doc(worker.id)
                                                .delete();
                                            setState(
                                              () => workers.removeAt(index),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Sil',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      exp.category,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    exp.date,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '- ₺${exp.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.grey),
                onPressed: () async {
                  await _db.collection('expenses').doc(exp.id).delete();
                  setState(() => expenses.remove(exp));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaleLogItem(Sale sale, int index) {
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
          Row(
            children: [
              Text(
                '+ ₺${sale.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (val) async {
                  if (val == 'duzenle') {
                    _showEditSaleDialog(sale, index);
                  } else if (val == 'sil') {
                    final plantIndex = plants.indexWhere(
                      (p) => p.name == sale.plantName,
                    );
                    if (plantIndex != -1) {
                      plants[plantIndex].stock += sale.quantity;
                      await _db
                          .collection('plants')
                          .doc(plants[plantIndex].id)
                          .update({'stock': plants[plantIndex].stock});
                    }
                    await _db.collection('sales').doc(sale.id).delete();
                    setState(() => sales.removeAt(index));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'duzenle', child: Text('Düzenle')),
                  const PopupMenuItem(
                    value: 'sil',
                    child: Text(
                      'Satışı Sil',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- DİALOGLAR (Tümü doğrudan Firebase'e yazacak şekilde güncellendi ve kategori seçeneği eklendi) ---
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
                          if (date.isNotEmpty)
                            setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        budgetController.text.isNotEmpty &&
                        selectedDateStr != "Tarih Seçilmedi") {
                      final newProj = Project(
                        name: nameController.text,
                        status: 'Devam Ediyor',
                        budget: double.tryParse(budgetController.text) ?? 0.0,
                        date: selectedDateStr,
                      );
                      final docRef = await _db
                          .collection('projects')
                          .add(newProj.toMap());
                      newProj.id = docRef.id;
                      setState(() => projects.add(newProj));
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

  void _showEditProjectDialog(Project proj, int index) {
    final nameController = TextEditingController(text: proj.name);
    final budgetController = TextEditingController(
      text: proj.budget.toStringAsFixed(0),
    );
    String selectedDateStr = proj.date;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Projeyi Düzenle'),
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
                    decoration: const InputDecoration(labelText: 'Bütçe (₺)'),
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
                          if (date.isNotEmpty)
                            setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    proj.name = nameController.text;
                    proj.budget =
                        double.tryParse(budgetController.text) ?? proj.budget;
                    proj.date = selectedDateStr;
                    await _db
                        .collection('projects')
                        .doc(proj.id)
                        .update(proj.toMap());
                    setState(() {});
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
      },
    );
  }

  // --- KATEGORİ SİSTEMİ BURAYA EKLENDİ ---
  void _showAddExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedDateStr = "Tarih Seçilmedi";
    String selectedCategory = expenseCategories.first;

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
                      labelText: 'Harcama Nedeni',
                    ),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tutar (₺)'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: [
                      ...expenseCategories.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                      const DropdownMenuItem(
                        value: 'yeni_ekle',
                        child: Text(
                          '+ Yeni Kategori Ekle',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val == 'yeni_ekle') {
                        _showAddCategoryDialog((yeniKategori) {
                          setModalState(() {
                            if (!expenseCategories.contains(yeniKategori)) {
                              expenseCategories.add(yeniKategori);
                              _db
                                  .collection('settings')
                                  .doc('categories')
                                  .update({
                                    'expenseCategories': expenseCategories,
                                  });
                            }
                            selectedCategory = yeniKategori;
                          });
                        });
                      } else if (val != null) {
                        setModalState(() => selectedCategory = val);
                      }
                    },
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
                          if (date.isNotEmpty)
                            setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedDateStr != "Tarih Seçilmedi") {
                      final newExp = Expense(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: selectedDateStr,
                        category: selectedCategory,
                      );
                      final docRef = await _db
                          .collection('expenses')
                          .add(newExp.toMap());
                      newExp.id = docRef.id;
                      setState(() => expenses.add(newExp));
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

  void _showAddCategoryDialog(Function(String) onAdded) {
    final catController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Kategori'),
          content: TextField(
            controller: catController,
            decoration: const InputDecoration(hintText: 'Örn: Yemek, Malzeme'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (catController.text.isNotEmpty) {
                  onAdded(catController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
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
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    stockController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  final newPlant = Plant(
                    name: nameController.text,
                    stock: int.tryParse(stockController.text) ?? 0,
                    price: double.tryParse(priceController.text) ?? 0.0,
                  );
                  final docRef = await _db
                      .collection('plants')
                      .add(newPlant.toMap());
                  newPlant.id = docRef.id;
                  setState(() => plants.add(newPlant));
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
              onPressed: () async {
                plant.name = nameController.text;
                plant.stock = int.tryParse(stockController.text) ?? plant.stock;
                plant.price =
                    double.tryParse(priceController.text) ?? plant.price;
                await _db
                    .collection('plants')
                    .doc(plant.id)
                    .update(plant.toMap());
                setState(() {});
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
          content: Text('Önce stok bölümünden bitki tanımlamalısınız!'),
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
                      items: plants
                          .map(
                            (Plant value) => DropdownMenuItem<Plant>(
                              value: value,
                              child: Text(
                                '${value.name} (Stok: ${value.stock})',
                              ),
                            ),
                          )
                          .toList(),
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
                            if (date.isNotEmpty)
                              setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    final int qty = int.tryParse(quantityController.text) ?? 1;
                    final double customPrice =
                        double.tryParse(priceController.text) ??
                        selectedPlant.price;

                    if (selectedPlant.stock >= qty) {
                      selectedPlant.stock -= qty;
                      await _db
                          .collection('plants')
                          .doc(selectedPlant.id)
                          .update({'stock': selectedPlant.stock});

                      final newSale = Sale(
                        plantName: selectedPlant.name,
                        quantity: qty,
                        totalAmount: customPrice * qty,
                        customerName: customerController.text,
                        date: selectedDateStr == "Tarih Seçilmedi"
                            ? "Bugün"
                            : selectedDateStr,
                      );
                      final docRef = await _db
                          .collection('sales')
                          .add(newSale.toMap());
                      newSale.id = docRef.id;

                      setState(() => sales.add(newSale));
                      Navigator.pop(context);
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

  void _showEditSaleDialog(Sale sale, int index) {
    final int oldQty = sale.quantity;
    final plantIndex = plants.indexWhere((p) => p.name == sale.plantName);
    final quantityController = TextEditingController(
      text: sale.quantity.toString(),
    );
    final customerController = TextEditingController(text: sale.customerName);
    final priceController = TextEditingController(
      text: (sale.totalAmount / sale.quantity).toStringAsFixed(0),
    );
    String selectedDateStr = sale.date;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text('${sale.plantName} Satışını Düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                            if (date.isNotEmpty)
                              setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    final int newQty =
                        int.tryParse(quantityController.text) ?? oldQty;
                    final double customPrice =
                        double.tryParse(priceController.text) ??
                        (sale.totalAmount / oldQty);

                    if (plantIndex != -1) {
                      final availableStock = plants[plantIndex].stock + oldQty;
                      if (availableStock >= newQty) {
                        plants[plantIndex].stock = availableStock - newQty;
                        await _db
                            .collection('plants')
                            .doc(plants[plantIndex].id)
                            .update({'stock': plants[plantIndex].stock});

                        sale.quantity = newQty;
                        sale.totalAmount = customPrice * newQty;
                        sale.customerName = customerController.text;
                        sale.date = selectedDateStr;
                        await _db
                            .collection('sales')
                            .doc(sale.id)
                            .update(sale.toMap());

                        setState(() {});
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hata: Stokta yeterli bitki yok!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      sale.quantity = newQty;
                      sale.totalAmount = customPrice * newQty;
                      sale.customerName = customerController.text;
                      sale.date = selectedDateStr;
                      await _db
                          .collection('sales')
                          .doc(sale.id)
                          .update(sale.toMap());
                      setState(() {});
                      Navigator.pop(context);
                    }
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
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    wageController.text.isNotEmpty) {
                  final newWorker = Worker(
                    name: nameController.text,
                    dailyWage: double.tryParse(wageController.text) ?? 0.0,
                  );
                  final docRef = await _db
                      .collection('workers')
                      .add(newWorker.toMap());
                  newWorker.id = docRef.id;
                  setState(() => workers.add(newWorker));
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
                          if (date.isNotEmpty)
                            setModalState(() => selectedDateStr = date);
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
                  onPressed: () async {
                    final double pay =
                        double.tryParse(paymentController.text) ?? 0.0;
                    if (pay > 0 && selectedDateStr != "Tarih Seçilmedi") {
                      worker.totalWagesDue -= pay;
                      if (worker.totalWagesDue < 0) worker.totalWagesDue = 0;

                      await _db.collection('workers').doc(worker.id).update({
                        'totalWagesDue': worker.totalWagesDue,
                      });

                      final newExp = Expense(
                        title: '${worker.name} Ödemesi',
                        amount: pay,
                        date: selectedDateStr,
                        category: 'Maaş',
                      );
                      final docRef = await _db
                          .collection('expenses')
                          .add(newExp.toMap());
                      newExp.id = docRef.id;

                      setState(() => expenses.add(newExp));
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
