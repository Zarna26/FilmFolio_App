import 'package:filmfolio/controllers/content_controller.dart';
import 'package:filmfolio/controllers/user_controller.dart';
import 'package:filmfolio/services/auth_service.dart';
import 'package:filmfolio/ui/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../models/user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  String username = '';
  List<Movie> reviewedMovies = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    UserController userController = UserController();
    User? loadedUser = await userController.loadUserFromLocalStorage();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
        username = loadedUser.name;
      });
      _loadReviewedMovies(loadedUser.id);
    }
  }

  Future<void> _loadReviewedMovies(String userId) async {
    ContentController _contentController = ContentController();
    List<Movie> allMovies = await _contentController.getAllMovies();

    // Filter only movies that have reviews made by the current user
    List<Movie> moviesWithUserReviews = allMovies.where((movie) {
      return movie.reviews?.any((review) => review.username == username) ?? false;
    }).toList();

    setState(() {
      reviewedMovies = moviesWithUserReviews;
    });
  }

  void _logOut(BuildContext context) async {
    try {
      final AuthService auth = AuthService();
      await auth.signOut();
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: ((context) => AlertDialog(
          title: Text(e.toString()),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10, 10, 0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserFullProfile(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                // Navigate to Notifications
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _logOut(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row with User Icon and Settings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.perm_identity_rounded,
                        color: Colors.amber,
                        size: 40.0,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        username.isNotEmpty ? username : 'Guest',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Settings Icon
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reviewed Movies Section
            const Text(
              "Reviewed Movies",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),

            Expanded(
              child: reviewedMovies.isNotEmpty
                  ? ListView.builder(
                itemCount: reviewedMovies.length,
                itemBuilder: (context, index) {
                  Movie movie = reviewedMovies[index];
                  return Card(
                    color: Colors.grey[850],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              movie.thumbnailUrl ?? 'https://via.placeholder.com/100x150',  // Fallback image if URL is null
                              width: 60,  // Adjust size as necessary
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),  // Spacing between image and movie details

                          // Movie Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Movie Title
                                Text(
                                  movie.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // All reviews for the movie
                                ...movie.reviews?.map((review) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Display review information with bold and amber color for username
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${review.username} : ',  // Username with bold and amber color
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            TextSpan(
                                              text: review.reviewText,  // Review text with normal styling
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  );
                                }).toList() ?? [],
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: const Text(
                  'No reviewed movies yet.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}



// import 'package:filmfolio/controllers/content_controller.dart';
// import 'package:filmfolio/controllers/user_controller.dart';
// import 'package:filmfolio/services/auth_service.dart';
// import 'package:filmfolio/ui/screens/user_profile_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../models/movie.dart';
// import '../../models/user.dart';
//
// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});
//
//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }
//
// class _AccountScreenState extends State<AccountScreen> {
//   User? user;
//   String username = '';
//   List<Movie> reviewedMovies = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     UserController userController = UserController();
//     User? loadedUser = await userController.loadUserFromLocalStorage();
//     if (loadedUser != null) {
//       setState(() {
//         user = loadedUser;
//         username = loadedUser.name;
//       });
//       _loadReviewedMovies(loadedUser.id);
//     }
//   }
//
//   Future<void> _loadReviewedMovies(String userId) async {
//     ContentController _contentController = ContentController();
//     List<Movie> allMovies = await _contentController.getAllMovies();
//     List<Movie> moviesWithUserReviews = allMovies.where((movie) {
//       return movie.reviews?.any((review) => review.username == username) ??
//           false;
//     }).toList();
//
//     setState(() {
//       reviewedMovies = moviesWithUserReviews;
//     });
//   }
//
//   void _logOut(BuildContext context) async {
//     try {
//       final AuthService auth = AuthService();
//       await auth.signOut();
//     } on Exception catch (e) {
//       showDialog(
//         context: context,
//         builder: ((context) => AlertDialog(
//               title: Text(e.toString()),
//             )),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.amber,
//               ),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(0.0, 10, 10, 0),
//                 child: Text(
//                   'Settings',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserFullProfile(),
//                   ),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.notifications),
//               title: Text('Notifications'),
//               onTap: () {
//                 // Navigate to Notifications
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () => _logOut(context),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.perm_identity_rounded,
//                         color: Colors.amber,
//                         size: 30.0,
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         username,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Builder(
//                   builder: (context) {
//                     return IconButton(
//                       icon: const Icon(
//                         Icons.settings,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Scaffold.of(context).openEndDrawer();
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: Column(
//                 children: [
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     child: const Text(
//                       "Reviewed Movies",
//                       style: TextStyle(
//                         color: Colors.amber,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: reviewedMovies.length,
//                       itemBuilder: (context, index) {
//                         Movie movie = reviewedMovies[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text(
//                               movie.name,
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: movie.reviews?.map((review) {
//                                     return Text(
//                                       '${review.username}: ${review.reviewText}',
//                                       style: TextStyle(color: Colors.black),
//                                     );
//                                   }).toList() ??
//                                   [],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const Divider(color: Colors.grey),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
