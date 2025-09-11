import 'package:chronolift/database/dao/category_dao.dart';
import 'package:chronolift/database/dao/exercise_dao.dart';
import 'package:chronolift/database/database.dart';
import 'package:chronolift/services/global_user_service.dart';
import 'package:drift/drift.dart';
// import 'package:flutter/material.dart';

Future<void> seedDefaultsIfEmpty(AppDatabase db) async {
  // FOR TESTING: Deletes all categories and exercises in case I mess up
  // final catDeletionCount = await CategoryDao(db).clearAllCategories();
  // final exerDeletionCount = await ExerciseDao(db).clearallExercises();

  // print(catDeletionCount);
  // print(exerDeletionCount);
  // END OF TESTING CODE

  final categoryCount = await CategoryDao(db).getAllCategories();
  final exerciseCount = await ExerciseDao(db).getAllExercises();

  final globalUser = GlobalUserService.instance;
  final uuid = globalUser.currentUserUuid!;

  // Category and Exercises Table should only be empty on start-up
  // Technically a user could delete all exercises/categories, then this func
  // will repopulate the tables. But that won't happen.
  if (categoryCount.isEmpty) {
    for (final cat in defaultCategories) {
      await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              uuid: uuid,
              name: cat['name']!,
              description: Value(cat['description']),
            ),
          );
    }
  }

  if (exerciseCount.isEmpty) {
    for (final ex in defaultExercises) {
      // manually grab category Id using name
      // TODO: Clean this mess up
      final category =
          await db.categoryDao.getCategoryByName(ex['categoryId']!);
      if (category == null) {
        continue;
      }
      await db.into(db.exercises).insert(
            ExercisesCompanion.insert(
              uuid: uuid,
              name: ex['name']!,
              categoryId: category.id,
              instructions: Value(ex['instructions']),
            ),
          );
    }
  }
}

final defaultCategories = [
  {
    'name': 'Chest',
    'description': 'Exercises for Pectoral muscles',
  },
  {
    'name': 'Back',
    'description': 'Exercises for Lats, Traps, Rhomboids, Erector Spinae',
  },
  {
    'name': 'Shoulders',
    'description': 'Exercises for Deltoids',
  },
  {
    'name': 'Arms',
    'description': 'Exercises for Biceps, Triceps, Forearms',
  },
  {
    'name': 'Legs',
    'description': 'Exercises for Quadriceps, Hamstrings, Glutes, Calves',
  },
  {
    'name': 'Core',
    'description': 'Exercises for Abdominals, Obliques, Lower Back',
  },
];

final defaultExercises = [
  {
    "name": "Barbell Bench Press",
    "categoryId": "Chest",
    "instructions":
        "Lie on your back on a flat bench. Grip the barbell slightly wider than shoulder-width. Lower the barbell to your chest, then press it back up to the starting position."
  },
  {
    "name": "Dumbbell Flyes",
    "categoryId": "Chest",
    "instructions":
        "Lie on your back on a flat bench holding a dumbbell in each hand. With a slight bend in your elbows, lower the dumbbells out to your sides until they are level with your chest. Squeeze your chest muscles to bring the dumbbells back up to the starting position."
  },
  {
    "name": "Push-ups",
    "categoryId": "Chest",
    "instructions":
        "Start in a plank position with your hands shoulder-width apart. Lower your body until your chest nearly touches the floor. Push through your hands to return to the starting position."
  },
  {
    "name": "Incline Dumbbell Press",
    "categoryId": "Chest",
    "instructions":
        "Sit on an incline bench with a dumbbell in each hand. Press the dumbbells directly above your chest, then lower them back down to your shoulders."
  },
  {
    "name": "Dips (Chest emphasis)",
    "categoryId": "Chest",
    "instructions":
        "Grasp the parallel bars and lower your body by bending your elbows. Lean forward slightly to target the chest. Push back up to the starting position."
  },
  {
    "name": "Cable Crossover",
    "categoryId": "Chest",
    "instructions":
        "Stand in the center of a cable machine with the pulleys set high. Grab a handle in each hand and bring them together in front of your chest, squeezing your pectoral muscles. Slowly return to the starting position."
  },
  {
    "name": "Decline Bench Press",
    "categoryId": "Chest",
    "instructions":
        "Lie on a decline bench with your feet secured. Press a barbell or dumbbells from your lower chest up to the starting position."
  },
  {
    "name": "Chest Press Machine",
    "categoryId": "Chest",
    "instructions":
        "Sit on the machine with your back flat against the pad. Grab the handles and push them forward until your arms are fully extended. Slowly return to the starting position."
  },
  {
    "name": "Deadlifts",
    "categoryId": "Back",
    "instructions":
        "Stand with your feet shoulder-width apart and a loaded barbell in front of you. Hinge at your hips and knees to grab the bar. Keeping your back straight, lift the bar by extending your hips and knees. Lower the bar back down with control."
  },
  {
    "name": "Pull-ups",
    "categoryId": "Back",
    "instructions":
        "Hang from a pull-up bar with an overhand grip. Pull your body up until your chin is over the bar. Lower yourself back down with control."
  },
  {
    "name": "Lat Pulldowns",
    "categoryId": "Back",
    "instructions":
        "Sit at a lat pulldown machine and grab the bar with a wide, overhand grip. Pull the bar down to your upper chest, squeezing your lats. Slowly return to the starting position."
  },
  {
    "name": "Bent-over Barbell Rows",
    "categoryId": "Back",
    "instructions":
        "Stand with your feet shoulder-width apart and a barbell in front of you. Hinge at your hips until your torso is nearly parallel to the floor. Pull the barbell up to your lower chest, squeezing your back muscles. Lower the bar back down with control."
  },
  {
    "name": "T-Bar Rows",
    "categoryId": "Back",
    "instructions":
        "Stand over a T-bar row machine or a barbell wedged in a corner. Grab the handles and pull the weight up to your chest, squeezing your lats. Lower the weight back down with control."
  },
  {
    "name": "Seated Cable Rows",
    "categoryId": "Back",
    "instructions":
        "Sit at a cable row machine with your feet on the footplate. Grab the handle and pull it toward your abdomen, keeping your back straight. Squeeze your shoulder blades together. Slowly return to the starting position."
  },
  {
    "name": "Chin-ups",
    "categoryId": "Back",
    "instructions":
        "Hang from a pull-up bar with an underhand grip. Pull your body up until your chin is over the bar. Lower yourself back down with control."
  },
  {
    "name": "Renegade Rows",
    "categoryId": "Back",
    "instructions":
        "Start in a high plank position with your hands on dumbbells. Row one dumbbell up toward your chest, then lower it back down. Repeat on the other side."
  },
  {
    "name": "Good Mornings",
    "categoryId": "Legs",
    "instructions":
        "Place a barbell across your upper back. Hinge at your hips, keeping your legs straight or with a slight bend, until your torso is parallel to the floor. Return to the starting position."
  },
  {
    "name": "Hyperextensions (Back Extensions)",
    "categoryId": "Back",
    "instructions":
        "Lie face down on a hyperextension bench with your feet secured. Hinge at your hips and lower your torso toward the floor. Raise your torso back up until it is in line with your legs."
  },
  {
    "name": "Overhead Press (Barbell)",
    "categoryId": "Shoulders",
    "instructions":
        "Stand with a barbell racked at your shoulders. Press the barbell directly overhead until your arms are fully extended. Lower the barbell back to your shoulders with control."
  },
  {
    "name": "Dumbbell Shoulder Press",
    "categoryId": "Shoulders",
    "instructions":
        "Sit on a bench with back support, holding a dumbbell in each hand at shoulder height. Press the dumbbells overhead until your arms are fully extended. Lower the dumbbells back down to shoulder height with control."
  },
  {
    "name": "Lateral Raises",
    "categoryId": "Shoulders",
    "instructions":
        "Stand with a dumbbell in each hand at your sides. With a slight bend in your elbows, raise the dumbbells out to your sides until they are level with your shoulders. Slowly lower them back down."
  },
  {
    "name": "Front Raises",
    "categoryId": "Shoulders",
    "instructions":
        "Stand with a dumbbell in each hand in front of your thighs. Keeping your arms straight, raise the dumbbells directly in front of you until they are level with your shoulders. Slowly lower them back down."
  },
  {
    "name": "Arnold Press",
    "categoryId": "Shoulders",
    "instructions":
        "Sit on a bench holding a dumbbell in each hand with your palms facing you. As you press the dumbbells overhead, rotate your wrists so your palms face forward at the top of the movement. Lower and rotate back to the starting position."
  },
  {
    "name": "Face Pulls",
    "categoryId": "Shoulders",
    "instructions":
        "Set a cable pulley at eye level. Grab the rope attachment and pull it toward your face, externally rotating your shoulders. Squeeze your rear delts and upper back. Slowly return to the starting position."
  },
  {
    "name": "Upright Rows",
    "categoryId": "Shoulders",
    "instructions":
        "Stand with a barbell or dumbbells in front of your thighs. Pull the weight straight up toward your chin, leading with your elbows. Slowly lower the weight back down."
  },
  {
    "name": "Reverse Pec Deck Flyes",
    "categoryId": "Shoulders",
    "instructions":
        "Sit on the machine facing the pad. Grab the handles and pull them back, squeezing your shoulder blades together. Slowly return to the starting position."
  },
  {
    "name": "Seated Dumbbell Lateral Raise",
    "categoryId": "Shoulders",
    "instructions":
        "Sit on a bench with a dumbbell in each hand. Perform lateral raises as you would standing, focusing on isolating the shoulder muscles."
  },
  {
    "name": "Barbell Squats",
    "categoryId": "Legs",
    "instructions":
        "Stand with a barbell on your upper back. Hinge at your hips and knees to lower your body as if sitting in a chair. Drive through your feet to return to the starting position."
  },
  {
    "name": "Leg Press",
    "categoryId": "Legs",
    "instructions":
        "Sit on the leg press machine with your feet on the platform. Push the platform away from you by extending your knees. Slowly return to the starting position."
  },
  {
    "name": "Lunges",
    "categoryId": "Legs",
    "instructions":
        "Step forward with one leg and lower your hips until both knees are bent at a 90-degree angle. Push off your front foot to return to the starting position. Repeat on the other leg."
  },
  {
    "name": "Romanian Deadlifts (RDLs)",
    "categoryId": "Legs",
    "instructions":
        "Hold a barbell or dumbbells in front of your thighs. Hinge at your hips, keeping your legs mostly straight, until you feel a stretch in your hamstrings. Return to the starting position by squeezing your glutes."
  },
  {
    "name": "Leg Extensions",
    "categoryId": "Legs",
    "instructions":
        "Sit on the machine and hook your legs under the pad. Extend your knees to lift the weight. Slowly lower the weight back down with control."
  },
  {
    "name": "Leg Curls",
    "categoryId": "Legs",
    "instructions":
        "Lie face down on the machine with your ankles under the pad. Curl your legs up toward your glutes. Slowly return to the starting position."
  },
  {
    "name": "Calf Raises",
    "categoryId": "Legs",
    "instructions":
        "Stand on a raised surface with the balls of your feet. Lower your heels below the platform, then press up onto your toes. Slowly return to the starting position."
  },
  {
    "name": "Glute Bridges",
    "categoryId": "Legs",
    "instructions":
        "Lie on your back with your knees bent and feet flat on the floor. Drive through your heels to lift your hips off the ground until your body forms a straight line from your shoulders to your knees. Slowly lower your hips back down."
  },
  {
    "name": "Box Jumps",
    "categoryId": "Legs",
    "instructions":
        "Stand in front of a box. Bend your knees and hips, then explosively jump onto the box, landing softly. Step or jump back down."
  },
  {
    "name": "Goblet Squats",
    "categoryId": "Legs",
    "instructions":
        "Hold a single dumbbell or kettlebell against your chest. Perform a squat, keeping your chest up and elbows inside your knees. Push back up to the starting position."
  },
  {
    "name": "Barbell Bicep Curls",
    "categoryId": "Arms",
    "instructions":
        "Stand with a barbell in your hands, palms facing forward. Curl the barbell up toward your shoulders, squeezing your biceps. Slowly lower the barbell back down with control."
  },
  {
    "name": "Dumbbell Curls",
    "categoryId": "Arms",
    "instructions":
        "Stand or sit with a dumbbell in each hand. Curl the dumbbells up toward your shoulders, either at the same time or alternating arms. Slowly lower the dumbbells back down with control."
  },
  {
    "name": "Hammer Curls",
    "categoryId": "Arms",
    "instructions":
        "Stand or sit with a dumbbell in each hand, palms facing each other. Curl the dumbbells up toward your shoulders, keeping your palms neutral. Slowly lower the dumbbells back down."
  },
  {
    "name": "Skull Crushers (Lying Tricep Extensions)",
    "categoryId": "Arms",
    "instructions":
        "Lie on your back on a flat bench. Hold a barbell or dumbbells above your head with your arms extended. Lower the weight by bending your elbows until the weight is near your forehead. Extend your arms back to the starting position."
  },
  {
    "name": "Tricep Pushdowns",
    "categoryId": "Arms",
    "instructions":
        "Stand at a cable machine with the pulley set high. Grab the rope or bar attachment and push it down until your arms are fully extended. Slowly return to the starting position."
  },
  {
    "name": "Dips (Triceps emphasis)",
    "categoryId": "Arms",
    "instructions":
        "Grasp the parallel bars and lower your body by bending your elbows. Keep your torso upright to target the triceps. Push back up to the starting position."
  },
  {
    "name": "Preacher Curls",
    "categoryId": "Arms",
    "instructions":
        "Sit at a preacher curl bench with your upper arms resting on the pad. Grab a barbell or dumbbells and curl the weight up toward your shoulders. Slowly lower the weight back down with control."
  },
  {
    "name": "Overhead Tricep Extensions",
    "categoryId": "Arms",
    "instructions":
        "Stand or sit with a dumbbell held behind your head with both hands. Extend your arms overhead until they are fully straight. Slowly lower the weight back behind your head."
  },
  {
    "name": "Concentration Curls",
    "categoryId": "Arms",
    "instructions":
        "Sit on a bench with your legs wide apart. Lean forward and rest your tricep on your inner thigh. Curl a dumbbell up toward your shoulder, squeezing your bicep. Slowly lower the weight back down."
  },
  {
    "name": "Reverse Curls",
    "categoryId": "Arms",
    "instructions":
        "Stand with a barbell in your hands, palms facing down. Curl the barbell up toward your shoulders. Slowly lower the barbell back down with control."
  },
  {
    "name": "Plank",
    "categoryId": "Core",
    "instructions":
        "Start in a push-up position, then drop to your forearms. Keep your body in a straight line from your head to your heels. Hold for a set amount of time."
  },
  {
    "name": "Crunches",
    "categoryId": "Core",
    "instructions":
        "Lie on your back with your knees bent and feet flat on the floor. Place your hands behind your head or crossed over your chest. Lift your shoulders off the floor, contracting your abs. Slowly lower back down."
  },
  {
    "name": "Leg Raises",
    "categoryId": "Core",
    "instructions":
        "Lie on your back with your legs straight. Keeping your legs straight, lift them up toward the ceiling until they are at a 90-degree angle. Slowly lower them back down without touching the floor."
  },
  {
    "name": "Russian Twists",
    "categoryId": "Core",
    "instructions":
        "Sit on the floor with your knees bent and feet off the ground. Lean back slightly and hold a weight plate or medicine ball. Rotate your torso from side to side, touching the weight to the floor on each side."
  },
  {
    "name": "Bicycle Crunches",
    "categoryId": "Core",
    "instructions":
        "Lie on your back with your hands behind your head. Bring your right elbow to your left knee as you extend your right leg. Alternate sides in a pedaling motion."
  },
  {
    "name": "Sit-ups",
    "categoryId": "Core",
    "instructions":
        "Lie on your back with your knees bent and feet flat on the floor. Raise your torso all the way up until it is perpendicular to the floor. Slowly lower yourself back down."
  },
  {
    "name": "Hanging Leg Raises",
    "categoryId": "Core",
    "instructions":
        "Hang from a pull-up bar. Keeping your legs straight or slightly bent, raise your legs up toward your chest. Slowly lower them back down with control."
  },
  {
    "name": "Side Planks",
    "categoryId": "Core",
    "instructions":
        "Lie on your side with your elbow directly under your shoulder. Lift your hips off the floor, creating a straight line from your head to your feet. Hold for a set amount of time. Repeat on the other side."
  },
  {
    "name": "Mountain Climbers",
    "categoryId": "Core",
    "instructions":
        "Start in a high plank position. Alternately bring your knees toward your chest in a running motion. Keep your core tight and your hips stable."
  },
  {
    "name": "Flutter Kicks",
    "categoryId": "Core",
    "instructions":
        "Lie on your back with your legs straight and hands under your glutes for support. Lift your head and shoulders off the floor. Alternately raise and lower your legs in a small, controlled kicking motion."
  }
];
