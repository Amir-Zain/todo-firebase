import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TaskItem extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  const TaskItem({Key? key, required this.date, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Material(
      elevation: 0.5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Color(0xff1c299c),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 10.h,
          // width: 90.w,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white60)),
                      child: CircleAvatar(
                        radius: 20.sp,
                        backgroundColor:
                        Colors.white60.withOpacity(.1),
                        child: Icon(
                          Icons.image_outlined,
                          size: 20,
                          color: Colors.red[400],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54),
                        ),
                      ],
                    )
                  ],
                ),
                Text(date)
              ],
            ),
          )),
    );
  }
}
