import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selected = 'credit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('付款資訊'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('選擇付款方式', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _PaymentOption(
            value: 'credit',
            groupValue: _selected,
            icon: Icons.credit_card,
            title: '信用卡',
            subtitle: '支援 VISA / Mastercard / JCB',
            onChanged: (v) => setState(() => _selected = v!),
          ),
          _PaymentOption(
            value: 'linepay',
            groupValue: _selected,
            icon: Icons.chat_bubble_outline,
            title: 'LINE Pay',
            subtitle: '使用 LINE Pay 快速付款',
            onChanged: (v) => setState(() => _selected = v!),
          ),
          const SizedBox(height: 24),
          if (_selected == 'credit') ...[
            Text('信用卡資訊', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: '卡號',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: '有效期限',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.chat_bubble, size: 48, color: Color(0xFF00B900)),
                    const SizedBox(height: 8),
                    const Text('結帳時將自動開啟 LINE Pay 完成付款'),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('連結 LINE Pay 帳號'),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('付款資訊已儲存')),
              );
              Navigator.pop(context);
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        onTap: () => onChanged(value),
      ),
    );
  }
}
