import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class SentimentAnalysisScreen extends StatefulWidget {
  @override
  _SentimentAnalysisScreenState createState() => _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  bool _isLoading = false;
  List<Message> _messages = [];
  Map<String, double> _averageSentiment = {
    'Positive': 0,
    'Negative': 0,
    'Neutral': 0,
  };
    final String _conversationId = '681eab99da2f571436af7656';

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
      _messages = [];
      _averageSentiment = {
        'Positive': 0,
        'Negative': 0,
        'Neutral': 0,
      };
    });

    try {
      // Fetch messages for the conversation
      final messagesResponse = await http.get(
        Uri.parse('https://dating-app-api-h6tc.onrender.com/api/message/$_conversationId'),
      );

      if (messagesResponse.statusCode == 200) {
        final messagesData = jsonDecode(messagesResponse.body);
        final List<dynamic> messagesList = messagesData['data'];
        print('messagesList: $messagesData');
        // Convert to Message objects and store
        _messages = messagesList.map((data) => Message.fromJson(data)).toList();

        // Limit to 10 messages
        if (_messages.length > 10) {
          _messages = _messages.sublist(0, 10);
        }

        // Analyze each message
        await _analyzeMessages();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeMessages() async {
    if (_messages.isEmpty) return;

    double positiveSum = 0;
    double negativeSum = 0;
    double neutralSum = 0;

    for (final message in _messages) {
      try {
        final sentimentResponse = await http.post(
          Uri.parse('http://10.0.2.2:8000/predict'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'text': message.text}),
        );

        if (sentimentResponse.body.isNotEmpty) {
          print('sentimentResponse: ${sentimentResponse.body}');
          final sentimentData = jsonDecode(sentimentResponse.body);
          message.sentimentResult = SentimentResult.fromJson(sentimentData);

          // Add to running totals
          positiveSum += message.sentimentResult?.sentimentScores['Positive'] ?? 0;
          negativeSum += message.sentimentResult?.sentimentScores['Negative'] ?? 0;
          neutralSum += (message.sentimentResult?.sentimentScores['Neutral'] ?? 0) +
              (message.sentimentResult?.sentimentScores['Irrelevant'] ?? 0);
        }
      } catch (e) {
        print('Error analyzing message: $e');
      }
    }

    // Calculate averages
    final int count = _messages.length;
    if (count > 0) {
      setState(() {
        _averageSentiment = {
          'Positive': positiveSum / count,
          'Negative': negativeSum / count,
          'Neutral': neutralSum / count,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation Sentiment Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Conversation ID: $_conversationId',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ],
            ),
            SizedBox(height: 24),

            // Results section
            if (_isLoading && _messages.isEmpty)
              Expanded(
                  child: Center(child: CircularProgressIndicator())
              )
            else if (_messages.isNotEmpty) ...[
              // Average sentiment visualization
              Text(
                'Average Sentiment Analysis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.green,
                        value: _averageSentiment['Positive']! * 100,
                        title: 'Positive\n${(_averageSentiment['Positive']! * 100).toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: _averageSentiment['Negative']! * 100,
                        title: 'Negative\n${(_averageSentiment['Negative']! * 100).toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.grey,
                        value: _averageSentiment['Neutral']! * 100,
                        title: 'Neutral\n${(_averageSentiment['Neutral']! * 100).toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Messages list with sentiment labels
              Text(
                'Messages',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final sentiment = message.sentimentResult?.predictedSentiment ?? 'Unknown';
                    Color sentimentColor;

                    if (sentiment == 'Positive') {
                      sentimentColor = Colors.green;
                    } else if (sentiment == 'Negative') {
                      sentimentColor = Colors.red;
                    } else {
                      sentimentColor = Colors.grey;
                    }

                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(message.text),
                        subtitle: Text('Sender: ${message.sender}'),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: sentimentColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sentiment,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class Message {
  final String id;
  final String text;
  final String sender;
  final String receiver;
  final String conversation;
  final DateTime createdAt;
  SentimentResult? sentimentResult;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.receiver,
    required this.conversation,
    required this.createdAt,
    this.sentimentResult,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      text: json['text'],
      sender: json['sender'],
      receiver: json['receiver'],
      conversation: json['conversation'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class SentimentResult {
  final String text;
  final String cleanText;
  final String predictedSentiment;
  final Map<String, double> sentimentScores;

  SentimentResult({
    required this.text,
    required this.cleanText,
    required this.predictedSentiment,
    required this.sentimentScores,
  });

  factory SentimentResult.fromJson(Map<String, dynamic> json) {
    return SentimentResult(
      text: json['text'],
      cleanText: json['clean_text'],
      predictedSentiment: json['predicted_sentiment'],
      sentimentScores: Map<String, double>.from(json['sentiment_scores']),
    );
  }
}