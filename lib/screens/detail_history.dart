import 'package:autivision/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

class DetailHistoryScreen extends StatelessWidget {
  final Map<String, dynamic> historyItem;

  DetailHistoryScreen({required this.historyItem});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd/MM/yyyy', 'id');
    final timeFormat = DateFormat('HH.mm', 'id');
    final formattedDate = dateFormat.format(historyItem['timestamp'].toDate());
    final formattedTime = timeFormat.format(historyItem['timestamp'].toDate());
    final formattedConfidence = historyItem['confidence'] / 100;
    final confidence = (formattedConfidence * 100).toStringAsFixed(2);

    Color statusColor;
    IconData statusIcon;

    if (historyItem['classification'] == 'Autistic') {
      statusColor = Colors.red;
      statusIcon = Icons.error_outline;
    } else if (historyItem['classification'] == 'Non Autistic') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
    } else {
      statusColor = Colors.grey;
      statusIcon = Icons.help_outline;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Riwayat',
        showLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: historyItem['imageUrl'],
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 180);
                    },
                  ),
                ),
                SizedBox(width: 30),
                CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: formattedConfidence,
                  center: Text(
                    "${confidence}%",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: statusColor),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: statusColor,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${historyItem['classification']}',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                SizedBox(width: 5),
                Icon(statusIcon, color: statusColor),
              ],
            ),
            SizedBox(height: 10),
            if (historyItem['classification'] == 'Autistic')
              Center(
                child: Text(
                  'Kemungkinan anak Anda mengalami gangguan spektrum autis.\nSegera konsultasikan ke dokter spesialis anak.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (historyItem['classification'] == 'Non Autistic')
              Center(
                child: Text(
                  'Anak Anda kemungkinan tidak mengalami gangguan spektrum autis.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (historyItem['classification'] == 'Unknown')
              Center(
                child: Text(
                  'Tidak dapat memprediksi hasil klasifikasi.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 20),
            Divider(color: Colors.black26),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Colors.black54),
                SizedBox(width: 5),
                Text(
                  'Waktu: $formattedTime',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.black54),
                SizedBox(width: 5),
                Text(
                  'Tanggal: $formattedDate',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
