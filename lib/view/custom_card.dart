import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String logoUrl;
  final String title;
  final String content;
  final VoidCallback onTap;

  CustomCard({
    required this.logoUrl,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        // Define the shape of the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // Define the child widget of the card
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add padding around the row widget
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add an image widget to display an image
                    Image.network(
                      logoUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/default-image.png',
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                    // Add some spacing between the image and the text
                    Container(width: 20),
                    // Add an expanded widget to take up the remaining horizontal space
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add some spacing between the top of the card and the title
                          Container(height: 5),
                          // Add a title widget
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37474F),
                            ),
                          ),
                          // Add some spacing between the title and the subtitle
                          Container(height: 5),
                          // Add a subtitle widget

                          // Add a text widget to display some text
                          Text(
                            content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
