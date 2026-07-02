import Foundation

enum SeedData {

    // MARK: - Exercises

    static let exercises: [Exercise] = [
        // Chest
        Exercise(id: "bench-press", nameUk: "Жим штанги лежачи", nameEn: "Barbell bench press", group: .chest, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 2, met: 6.0, tipsUk: "Лопатки зведені, стопи впираються в підлогу. Опускайте штангу до середини грудей.", tipsEn: "Keep your shoulder blades retracted and feet planted. Lower the bar to mid-chest."),
        Exercise(id: "dumbbell-press", nameUk: "Жим гантелей лежачи", nameEn: "Dumbbell bench press", group: .chest, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 2, met: 6.0, tipsUk: "Більша амплітуда, ніж зі штангою. Не стукайте гантелі одна об одну вгорі.", tipsEn: "Greater range of motion than a barbell. Don't clank the dumbbells together at the top."),
        Exercise(id: "incline-press", nameUk: "Жим на похилій лаві", nameEn: "Incline bench press", group: .chest, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 2, met: 6.0, tipsUk: "Кут лави 30-45°. Акцент на верхню частину грудей.", tipsEn: "Bench angle 30-45°. Emphasises the upper chest."),
        Exercise(id: "pushup", nameUk: "Віджимання", nameEn: "Push-ups", group: .chest, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 1, met: 8.0, tipsUk: "Тіло — пряма лінія. Лікті під кутом ~45° до корпуса.", tipsEn: "Body in a straight line. Elbows at about 45° to your torso."),
        Exercise(id: "dumbbell-fly", nameUk: "Розведення гантелей", nameEn: "Dumbbell flyes", group: .chest, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 1, met: 4.0, tipsUk: "Легкий згин у ліктях протягом усього руху. Відчувайте розтяг грудних.", tipsEn: "Slight bend in the elbows throughout. Feel the stretch in your chest."),
        Exercise(id: "dips", nameUk: "Віджимання на брусах", nameEn: "Dips", group: .chest, equipmentUk: "Бруси", equipmentEn: "Parallel bars", difficulty: 3, met: 8.0, tipsUk: "Нахил вперед — акцент на груди, вертикально — на трицепс.", tipsEn: "Lean forward to hit the chest, stay upright for the triceps."),
        // Back
        Exercise(id: "pullup", nameUk: "Підтягування", nameEn: "Pull-ups", group: .back, equipmentUk: "Турнік", equipmentEn: "Pull-up bar", difficulty: 3, met: 8.0, tipsUk: "Тягніться грудьми до перекладини, зводьте лопатки внизу руху.", tipsEn: "Pull your chest to the bar and squeeze your shoulder blades at the bottom."),
        Exercise(id: "lat-pulldown", nameUk: "Тяга верхнього блоку", nameEn: "Lat pulldown", group: .back, equipmentUk: "Блок", equipmentEn: "Cable", difficulty: 1, met: 5.0, tipsUk: "Тягніть до верху грудей, не відхиляйтесь сильно назад.", tipsEn: "Pull to the upper chest, don't lean back too much."),
        Exercise(id: "barbell-row", nameUk: "Тяга штанги в нахилі", nameEn: "Bent-over barbell row", group: .back, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 3, met: 6.0, tipsUk: "Спина пряма, корпус майже паралельний підлозі. Тягніть до поясу.", tipsEn: "Keep your back straight, torso nearly parallel to the floor. Pull to your waist."),
        Exercise(id: "dumbbell-row", nameUk: "Тяга гантелі в нахилі", nameEn: "One-arm dumbbell row", group: .back, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 2, met: 6.0, tipsUk: "Опора коліном і рукою на лаву. Тягніть лікоть уздовж корпуса.", tipsEn: "Support your knee and hand on a bench. Pull your elbow along your torso."),
        Exercise(id: "deadlift", nameUk: "Станова тяга", nameEn: "Deadlift", group: .back, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 3, met: 6.5, tipsUk: "Спина завжди пряма. Штанга рухається впритул до ніг.", tipsEn: "Keep your back straight at all times. The bar travels close to your legs."),
        Exercise(id: "seated-row", nameUk: "Тяга нижнього блоку", nameEn: "Seated cable row", group: .back, equipmentUk: "Блок", equipmentEn: "Cable", difficulty: 1, met: 5.0, tipsUk: "Корпус нерухомий, працюють тільки руки та лопатки.", tipsEn: "Keep your torso still — only your arms and shoulder blades work."),
        // Legs
        Exercise(id: "squat", nameUk: "Присідання зі штангою", nameEn: "Barbell squat", group: .legs, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 3, met: 6.0, tipsUk: "Коліна в напрямку носків, присідайте до паралелі стегна з підлогою.", tipsEn: "Knees track over your toes, descend until thighs are parallel to the floor."),
        Exercise(id: "goblet-squat", nameUk: "Гоблет-присідання", nameEn: "Goblet squat", group: .legs, equipmentUk: "Гантелі", equipmentEn: "Dumbbell", difficulty: 1, met: 5.5, tipsUk: "Гантель біля грудей, лікті всередині колін у нижній точці.", tipsEn: "Hold the dumbbell at your chest, elbows inside your knees at the bottom."),
        Exercise(id: "leg-press", nameUk: "Жим ногами", nameEn: "Leg press", group: .legs, equipmentUk: "Тренажер", equipmentEn: "Machine", difficulty: 1, met: 5.0, tipsUk: "Не випрямляйте коліна повністю у верхній точці.", tipsEn: "Don't lock your knees out completely at the top."),
        Exercise(id: "lunges", nameUk: "Випади", nameEn: "Lunges", group: .legs, equipmentUk: "Власна вага / гантелі", equipmentEn: "Bodyweight / dumbbells", difficulty: 2, met: 6.0, tipsUk: "Коліно передньої ноги не виходить за носок. Крок широкий.", tipsEn: "Front knee stays behind your toes. Take a wide step."),
        Exercise(id: "romanian-deadlift", nameUk: "Румунська тяга", nameEn: "Romanian deadlift", group: .legs, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 2, met: 5.5, tipsUk: "Ноги майже прямі, таз назад. Розтяг задньої поверхні стегна.", tipsEn: "Legs almost straight, hips back. Stretch the hamstrings."),
        Exercise(id: "leg-curl", nameUk: "Згинання ніг лежачи", nameEn: "Lying leg curl", group: .legs, equipmentUk: "Тренажер", equipmentEn: "Machine", difficulty: 1, met: 4.0, tipsUk: "Повільна негативна фаза, без ривків.", tipsEn: "Slow negative phase, no jerking."),
        Exercise(id: "calf-raise", nameUk: "Підйоми на носки", nameEn: "Calf raises", group: .legs, equipmentUk: "Власна вага / тренажер", equipmentEn: "Bodyweight / machine", difficulty: 1, met: 4.0, tipsUk: "Повна амплітуда: максимальний розтяг внизу, пауза вгорі.", tipsEn: "Full range: maximum stretch at the bottom, pause at the top."),
        // Shoulders
        Exercise(id: "overhead-press", nameUk: "Жим штанги стоячи", nameEn: "Standing overhead press", group: .shoulders, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 3, met: 6.0, tipsUk: "Прес напружений, не прогинайтесь у попереку.", tipsEn: "Brace your core, don't arch your lower back."),
        Exercise(id: "dumbbell-shoulder-press", nameUk: "Жим гантелей сидячи", nameEn: "Seated dumbbell press", group: .shoulders, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 2, met: 5.5, tipsUk: "Опустіть гантелі до рівня вух, не нижче.", tipsEn: "Lower the dumbbells to ear level, no lower."),
        Exercise(id: "lateral-raise", nameUk: "Махи гантелями в сторони", nameEn: "Lateral raises", group: .shoulders, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 1, met: 4.0, tipsUk: "Легка вага, лікті трохи зігнуті, підйом до рівня плечей.", tipsEn: "Light weight, elbows slightly bent, raise to shoulder level."),
        Exercise(id: "face-pull", nameUk: "Тяга канату до обличчя", nameEn: "Face pull", group: .shoulders, equipmentUk: "Блок", equipmentEn: "Cable", difficulty: 1, met: 4.0, tipsUk: "Розводьте канат до вух. Чудово для задніх дельт і постави.", tipsEn: "Pull the rope apart towards your ears. Great for rear delts and posture."),
        // Arms
        Exercise(id: "barbell-curl", nameUk: "Підйом штанги на біцепс", nameEn: "Barbell curl", group: .arms, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 1, met: 4.0, tipsUk: "Лікті притиснуті до корпуса, без розгойдування.", tipsEn: "Keep your elbows pinned to your torso, no swinging."),
        Exercise(id: "dumbbell-curl", nameUk: "Підйом гантелей на біцепс", nameEn: "Dumbbell curl", group: .arms, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 1, met: 4.0, tipsUk: "Супінація (розворот кисті) підсилює скорочення біцепса.", tipsEn: "Supinating (rotating the wrist) increases biceps contraction."),
        Exercise(id: "hammer-curl", nameUk: "Молотки", nameEn: "Hammer curls", group: .arms, equipmentUk: "Гантелі", equipmentEn: "Dumbbells", difficulty: 1, met: 4.0, tipsUk: "Нейтральний хват. Працює брахіаліс і передпліччя.", tipsEn: "Neutral grip. Works the brachialis and forearms."),
        Exercise(id: "triceps-pushdown", nameUk: "Розгинання на блоці", nameEn: "Triceps pushdown", group: .arms, equipmentUk: "Блок", equipmentEn: "Cable", difficulty: 1, met: 4.0, tipsUk: "Лікті нерухомі, повне розгинання внизу.", tipsEn: "Keep your elbows still, full extension at the bottom."),
        Exercise(id: "french-press", nameUk: "Французький жим", nameEn: "Lying triceps extension", group: .arms, equipmentUk: "Штанга", equipmentEn: "Barbell", difficulty: 2, met: 4.0, tipsUk: "Опускайте штангу до чола, лікті не розводьте.", tipsEn: "Lower the bar to your forehead, keep elbows in."),
        // Core
        Exercise(id: "plank", nameUk: "Планка", nameEn: "Plank", group: .core, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 1, met: 3.5, tipsUk: "Тіло — пряма лінія, таз підкручений, прес напружений. Рахуйте секунди як повтори.", tipsEn: "Body in a straight line, pelvis tucked, core braced. Count seconds as reps."),
        Exercise(id: "crunches", nameUk: "Скручування", nameEn: "Crunches", group: .core, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 1, met: 3.5, tipsUk: "Поперек притиснутий до підлоги, підйом за рахунок преса.", tipsEn: "Keep your lower back pressed to the floor, lift with your abs."),
        Exercise(id: "leg-raise", nameUk: "Підйоми ніг у висі", nameEn: "Hanging leg raises", group: .core, equipmentUk: "Турнік", equipmentEn: "Pull-up bar", difficulty: 3, met: 5.0, tipsUk: "Без розгойдування. Підкручуйте таз у верхній точці.", tipsEn: "No swinging. Tuck your pelvis at the top."),
        Exercise(id: "russian-twist", nameUk: "Російські скручування", nameEn: "Russian twists", group: .core, equipmentUk: "Власна вага / диск", equipmentEn: "Bodyweight / plate", difficulty: 2, met: 4.0, tipsUk: "Корпус відхилений на 45°, обертайте плечі, а не тільки руки.", tipsEn: "Torso leaned back ~45°, rotate your shoulders, not just your arms."),
        Exercise(id: "bicycle-crunch", nameUk: "Велосипед", nameEn: "Bicycle crunches", group: .core, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 1, met: 4.0, tipsUk: "Лікоть до протилежного коліна, темп контрольований.", tipsEn: "Elbow to the opposite knee, controlled tempo."),
        // Cardio
        Exercise(id: "running", nameUk: "Біг", nameEn: "Running", group: .cardio, equipmentUk: "—", equipmentEn: "—", difficulty: 2, met: 9.8, tipsUk: "Тримайте пульс у зоні 60-75% від максимального для жироспалення. 1 повтор = 1 хвилина.", tipsEn: "Keep your heart rate in the 60-75% zone for fat burning. 1 rep = 1 minute."),
        Exercise(id: "cycling", nameUk: "Велотренажер", nameEn: "Stationary bike", group: .cardio, equipmentUk: "Тренажер", equipmentEn: "Machine", difficulty: 1, met: 7.5, tipsUk: "Коліно трохи зігнуте в нижній точці педалі. 1 повтор = 1 хвилина.", tipsEn: "Knee slightly bent at the bottom of the pedal stroke. 1 rep = 1 minute."),
        Exercise(id: "jump-rope", nameUk: "Скакалка", nameEn: "Jump rope", group: .cardio, equipmentUk: "Скакалка", equipmentEn: "Jump rope", difficulty: 2, met: 11.0, tipsUk: "Стрибайте на носках, обертання за рахунок кистей. 1 повтор = 1 хвилина.", tipsEn: "Jump on the balls of your feet, rotate from the wrists. 1 rep = 1 minute."),
        Exercise(id: "rowing", nameUk: "Гребний тренажер", nameEn: "Rowing machine", group: .cardio, equipmentUk: "Тренажер", equipmentEn: "Machine", difficulty: 2, met: 8.5, tipsUk: "Послідовність: ноги → корпус → руки. 1 повтор = 1 хвилина.", tipsEn: "Sequence: legs → torso → arms. 1 rep = 1 minute."),
        Exercise(id: "burpee", nameUk: "Берпі", nameEn: "Burpees", group: .cardio, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 3, met: 10.0, tipsUk: "Тримайте темп, стрибок вгору з бавовною над головою.", tipsEn: "Keep a steady pace, jump up with a clap overhead."),
        // Full Body
        Exercise(id: "kettlebell-swing", nameUk: "Махи гирею", nameEn: "Kettlebell swings", group: .fullBody, equipmentUk: "Гиря", equipmentEn: "Kettlebell", difficulty: 2, met: 9.5, tipsUk: "Рух за рахунок вибухового розгинання таза, а не рук.", tipsEn: "Power comes from an explosive hip drive, not your arms."),
        Exercise(id: "thruster", nameUk: "Трастери", nameEn: "Thrusters", group: .fullBody, equipmentUk: "Гантелі / штанга", equipmentEn: "Dumbbells / barbell", difficulty: 3, met: 9.0, tipsUk: "Присідання + жим вгору одним рухом.", tipsEn: "A squat and an overhead press in one movement."),
        Exercise(id: "mountain-climber", nameUk: "Скелелаз", nameEn: "Mountain climbers", group: .fullBody, equipmentUk: "Власна вага", equipmentEn: "Bodyweight", difficulty: 1, met: 8.0, tipsUk: "Позиція планки, коліна по черзі до грудей у швидкому темпі.", tipsEn: "Plank position, drive knees to your chest alternately at a fast pace."),
    ]

    // MARK: - Workout Programs

    private static func sets(_ n: Int, reps: Int, weight: Double = 0) -> [SetEntry] {
        (0..<n).map { _ in SetEntry(reps: reps, weight: weight) }
    }

    static let templates: [WorkoutTemplate] = [
        WorkoutTemplate(
            nameUk: "Full Body для початківців", nameEn: "Full Body for beginners",
            subtitleUk: "Базові рухи на все тіло — ідеально для старту",
            subtitleEn: "Basic full-body moves — perfect to start",
            levelUk: "Початківець", levelEn: "Beginner",
            exercises: [
                WorkoutExercise(exerciseID: "goblet-squat", sets: sets(3, reps: 12, weight: 8), restSec: 90),
                WorkoutExercise(exerciseID: "pushup", sets: sets(3, reps: 10), restSec: 90),
                WorkoutExercise(exerciseID: "seated-row", sets: sets(3, reps: 12, weight: 25), restSec: 90),
                WorkoutExercise(exerciseID: "lateral-raise", sets: sets(3, reps: 15, weight: 4), restSec: 60),
                WorkoutExercise(exerciseID: "plank", sets: sets(3, reps: 40), restSec: 60),
            ]),
        WorkoutTemplate(
            nameUk: "Груди + трицепс", nameEn: "Chest + triceps",
            subtitleUk: "Класичний жимовий день",
            subtitleEn: "A classic push day",
            levelUk: "Середній", levelEn: "Intermediate",
            exercises: [
                WorkoutExercise(exerciseID: "bench-press", sets: sets(4, reps: 8, weight: 50), restSec: 120),
                WorkoutExercise(exerciseID: "incline-press", sets: sets(3, reps: 10, weight: 35), restSec: 90),
                WorkoutExercise(exerciseID: "dumbbell-fly", sets: sets(3, reps: 12, weight: 10), restSec: 60),
                WorkoutExercise(exerciseID: "dips", sets: sets(3, reps: 10), restSec: 90),
                WorkoutExercise(exerciseID: "triceps-pushdown", sets: sets(3, reps: 12, weight: 20), restSec: 60),
            ]),
        WorkoutTemplate(
            nameUk: "Спина + біцепс", nameEn: "Back + biceps",
            subtitleUk: "Тяговий день для широкої спини",
            subtitleEn: "A pull day for a wide back",
            levelUk: "Середній", levelEn: "Intermediate",
            exercises: [
                WorkoutExercise(exerciseID: "pullup", sets: sets(4, reps: 8), restSec: 120),
                WorkoutExercise(exerciseID: "barbell-row", sets: sets(4, reps: 10, weight: 40), restSec: 120),
                WorkoutExercise(exerciseID: "lat-pulldown", sets: sets(3, reps: 12, weight: 45), restSec: 90),
                WorkoutExercise(exerciseID: "barbell-curl", sets: sets(3, reps: 10, weight: 20), restSec: 60),
                WorkoutExercise(exerciseID: "hammer-curl", sets: sets(3, reps: 12, weight: 8), restSec: 60),
            ]),
        WorkoutTemplate(
            nameUk: "День ніг", nameEn: "Leg day",
            subtitleUk: "Присідання, тяги та все, що ви любите ненавидіти",
            subtitleEn: "Squats, pulls and everything you love to hate",
            levelUk: "Просунутий", levelEn: "Advanced",
            exercises: [
                WorkoutExercise(exerciseID: "squat", sets: sets(4, reps: 8, weight: 60), restSec: 150),
                WorkoutExercise(exerciseID: "romanian-deadlift", sets: sets(4, reps: 10, weight: 50), restSec: 120),
                WorkoutExercise(exerciseID: "leg-press", sets: sets(3, reps: 12, weight: 100), restSec: 90),
                WorkoutExercise(exerciseID: "lunges", sets: sets(3, reps: 12, weight: 10), restSec: 90),
                WorkoutExercise(exerciseID: "calf-raise", sets: sets(4, reps: 15, weight: 40), restSec: 60),
            ]),
        WorkoutTemplate(
            nameUk: "Плечі + прес", nameEn: "Shoulders + core",
            subtitleUk: "Дельти всіх пучків і міцний корпус",
            subtitleEn: "All three deltoid heads and a strong core",
            levelUk: "Середній", levelEn: "Intermediate",
            exercises: [
                WorkoutExercise(exerciseID: "overhead-press", sets: sets(4, reps: 8, weight: 30), restSec: 120),
                WorkoutExercise(exerciseID: "dumbbell-shoulder-press", sets: sets(3, reps: 10, weight: 14), restSec: 90),
                WorkoutExercise(exerciseID: "lateral-raise", sets: sets(4, reps: 15, weight: 6), restSec: 60),
                WorkoutExercise(exerciseID: "face-pull", sets: sets(3, reps: 15, weight: 15), restSec: 60),
                WorkoutExercise(exerciseID: "leg-raise", sets: sets(3, reps: 12), restSec: 60),
                WorkoutExercise(exerciseID: "russian-twist", sets: sets(3, reps: 20, weight: 5), restSec: 45),
            ]),
        WorkoutTemplate(
            nameUk: "HIIT кардіо", nameEn: "HIIT cardio",
            subtitleUk: "20 хвилин інтенсиву для жироспалення",
            subtitleEn: "20 minutes of intensity for fat burning",
            levelUk: "Середній", levelEn: "Intermediate",
            exercises: [
                WorkoutExercise(exerciseID: "jump-rope", sets: sets(3, reps: 2), restSec: 45),
                WorkoutExercise(exerciseID: "burpee", sets: sets(4, reps: 12), restSec: 60),
                WorkoutExercise(exerciseID: "mountain-climber", sets: sets(4, reps: 30), restSec: 45),
                WorkoutExercise(exerciseID: "kettlebell-swing", sets: sets(4, reps: 15, weight: 16), restSec: 60),
            ]),
    ]

    // MARK: - Foods (macros per 100 g)

    static let foods: [FoodItem] = [
        // Protein
        FoodItem(id: "chicken-breast", nameUk: "Куряче філе (варене)", nameEn: "Chicken breast (boiled)", kcal: 165, protein: 31, fat: 3.6, carbs: 0, category: .protein),
        FoodItem(id: "turkey", nameUk: "Індичка (філе)", nameEn: "Turkey (fillet)", kcal: 144, protein: 29, fat: 2.5, carbs: 0, category: .protein),
        FoodItem(id: "beef", nameUk: "Яловичина (тушкована)", nameEn: "Beef (stewed)", kcal: 232, protein: 26, fat: 14, carbs: 0, category: .protein),
        FoodItem(id: "salmon", nameUk: "Лосось (запечений)", nameEn: "Salmon (baked)", kcal: 208, protein: 20, fat: 13, carbs: 0, category: .protein),
        FoodItem(id: "tuna", nameUk: "Тунець (консервований)", nameEn: "Tuna (canned)", kcal: 116, protein: 26, fat: 1, carbs: 0, category: .protein),
        FoodItem(id: "eggs", nameUk: "Яйця курячі", nameEn: "Chicken eggs", kcal: 155, protein: 13, fat: 11, carbs: 1.1, category: .protein),
        FoodItem(id: "shrimp", nameUk: "Креветки", nameEn: "Shrimp", kcal: 99, protein: 24, fat: 0.3, carbs: 0.2, category: .protein),
        FoodItem(id: "protein-powder", nameUk: "Протеїн (порошок)", nameEn: "Protein (powder)", kcal: 380, protein: 75, fat: 5, carbs: 8, category: .protein),
        // Grains and sides
        FoodItem(id: "buckwheat", nameUk: "Гречка (варена)", nameEn: "Buckwheat (boiled)", kcal: 110, protein: 4.2, fat: 1.1, carbs: 21, category: .grain),
        FoodItem(id: "rice", nameUk: "Рис (варений)", nameEn: "Rice (boiled)", kcal: 130, protein: 2.7, fat: 0.3, carbs: 28, category: .grain),
        FoodItem(id: "oatmeal", nameUk: "Вівсянка (на воді)", nameEn: "Oatmeal (on water)", kcal: 88, protein: 3, fat: 1.7, carbs: 15, category: .grain),
        FoodItem(id: "pasta", nameUk: "Макарони (варені)", nameEn: "Pasta (boiled)", kcal: 158, protein: 5.8, fat: 0.9, carbs: 31, category: .grain),
        FoodItem(id: "potato", nameUk: "Картопля (варена)", nameEn: "Potato (boiled)", kcal: 82, protein: 2, fat: 0.1, carbs: 17, category: .grain),
        FoodItem(id: "bread-rye", nameUk: "Хліб житній", nameEn: "Rye bread", kcal: 259, protein: 8.5, fat: 3.3, carbs: 48, category: .grain),
        FoodItem(id: "quinoa", nameUk: "Кіноа (варена)", nameEn: "Quinoa (boiled)", kcal: 120, protein: 4.4, fat: 1.9, carbs: 21, category: .grain),
        // Dairy
        FoodItem(id: "cottage-cheese", nameUk: "Сир кисломолочний 5%", nameEn: "Cottage cheese 5%", kcal: 121, protein: 17, fat: 5, carbs: 1.8, category: .dairy),
        FoodItem(id: "greek-yogurt", nameUk: "Грецький йогурт 2%", nameEn: "Greek yogurt 2%", kcal: 73, protein: 10, fat: 2, carbs: 3.9, category: .dairy),
        FoodItem(id: "milk", nameUk: "Молоко 2.5%", nameEn: "Milk 2.5%", kcal: 52, protein: 2.8, fat: 2.5, carbs: 4.7, category: .dairy),
        FoodItem(id: "kefir", nameUk: "Кефір 2.5%", nameEn: "Kefir 2.5%", kcal: 50, protein: 2.9, fat: 2.5, carbs: 4, category: .dairy),
        FoodItem(id: "cheese", nameUk: "Сир твердий", nameEn: "Hard cheese", kcal: 352, protein: 26, fat: 27, carbs: 0, category: .dairy),
        // Fruit
        FoodItem(id: "banana", nameUk: "Банан", nameEn: "Banana", kcal: 89, protein: 1.1, fat: 0.3, carbs: 23, category: .fruit),
        FoodItem(id: "apple", nameUk: "Яблуко", nameEn: "Apple", kcal: 52, protein: 0.3, fat: 0.2, carbs: 14, category: .fruit),
        FoodItem(id: "orange", nameUk: "Апельсин", nameEn: "Orange", kcal: 47, protein: 0.9, fat: 0.1, carbs: 12, category: .fruit),
        FoodItem(id: "berries", nameUk: "Ягоди (мікс)", nameEn: "Berries (mixed)", kcal: 45, protein: 1, fat: 0.4, carbs: 10, category: .fruit),
        FoodItem(id: "avocado", nameUk: "Авокадо", nameEn: "Avocado", kcal: 160, protein: 2, fat: 15, carbs: 9, category: .fruit),
        FoodItem(id: "grapes", nameUk: "Виноград", nameEn: "Grapes", kcal: 69, protein: 0.7, fat: 0.2, carbs: 18, category: .fruit),
        // Vegetables
        FoodItem(id: "broccoli", nameUk: "Броколі", nameEn: "Broccoli", kcal: 34, protein: 2.8, fat: 0.4, carbs: 7, category: .vegetable),
        FoodItem(id: "cucumber", nameUk: "Огірок", nameEn: "Cucumber", kcal: 15, protein: 0.7, fat: 0.1, carbs: 3.6, category: .vegetable),
        FoodItem(id: "tomato", nameUk: "Помідор", nameEn: "Tomato", kcal: 18, protein: 0.9, fat: 0.2, carbs: 3.9, category: .vegetable),
        FoodItem(id: "salad-mix", nameUk: "Салат листовий", nameEn: "Leafy salad", kcal: 17, protein: 1.2, fat: 0.2, carbs: 3.3, category: .vegetable),
        FoodItem(id: "carrot", nameUk: "Морква", nameEn: "Carrot", kcal: 41, protein: 0.9, fat: 0.2, carbs: 10, category: .vegetable),
        // Snacks and sweets
        FoodItem(id: "nuts", nameUk: "Горіхи (мікс)", nameEn: "Nuts (mixed)", kcal: 607, protein: 20, fat: 54, carbs: 13, category: .snack),
        FoodItem(id: "peanut-butter", nameUk: "Арахісова паста", nameEn: "Peanut butter", kcal: 588, protein: 25, fat: 50, carbs: 20, category: .snack),
        FoodItem(id: "dark-chocolate", nameUk: "Чорний шоколад 70%", nameEn: "Dark chocolate 70%", kcal: 546, protein: 7.8, fat: 43, carbs: 46, category: .snack),
        FoodItem(id: "protein-bar", nameUk: "Протеїновий батончик", nameEn: "Protein bar", kcal: 350, protein: 30, fat: 12, carbs: 30, category: .snack),
        FoodItem(id: "cookies", nameUk: "Печиво вівсяне", nameEn: "Oatmeal cookies", kcal: 437, protein: 6.5, fat: 14, carbs: 71, category: .snack),
        FoodItem(id: "honey", nameUk: "Мед", nameEn: "Honey", kcal: 304, protein: 0.3, fat: 0, carbs: 82, category: .snack),
        // Drinks
        FoodItem(id: "orange-juice", nameUk: "Сік апельсиновий", nameEn: "Orange juice", kcal: 45, protein: 0.7, fat: 0.2, carbs: 10, category: .drink),
        FoodItem(id: "cola", nameUk: "Кола", nameEn: "Cola", kcal: 42, protein: 0, fat: 0, carbs: 10.6, category: .drink),
        FoodItem(id: "latte", nameUk: "Лате (з молоком 2.5%)", nameEn: "Latte (with 2.5% milk)", kcal: 40, protein: 2, fat: 1.5, carbs: 4.5, category: .drink),
        FoodItem(id: "smoothie", nameUk: "Смузі фруктовий", nameEn: "Fruit smoothie", kcal: 60, protein: 1, fat: 0.5, carbs: 13, category: .drink),
    ]

    // MARK: - Trainers

    static let trainers: [Trainer] = [
        Trainer(id: "t1", nameUk: "Олександр Коваленко", nameEn: "Oleksandr Kovalenko",
                specialtyUk: "Силові тренування", specialtyEn: "Strength training",
                bioUk: "Майстер спорту з пауерліфтингу. Допоможу поставити техніку базових рухів і скласти програму під ваші цілі — від перших кроків у залі до змагального рівня.",
                bioEn: "Master of Sport in powerlifting. I'll help you nail the technique of the basic lifts and build a program for your goals — from your first steps in the gym to competition level.",
                rating: 4.9, reviewsCount: 127, pricePerHour: 800, yearsExp: 9,
                icon: "figure.strengthtraining.traditional", colorName: "blue",
                tagsUk: ["Пауерліфтинг", "Техніка", "Складання програм"],
                tagsEn: ["Powerlifting", "Technique", "Programming"]),
        Trainer(id: "t2", nameUk: "Марина Шевченко", nameEn: "Maryna Shevchenko",
                specialtyUk: "Схуднення та тонус", specialtyEn: "Weight loss & toning",
                bioUk: "Сертифікований нутриціолог і тренер. Спеціалізуюсь на комплексному підході: тренування + харчування. Понад 200 клієнтів досягли своєї цільової ваги.",
                bioEn: "Certified nutritionist and trainer. I specialise in a holistic approach: training plus nutrition. Over 200 clients have reached their target weight.",
                rating: 5.0, reviewsCount: 214, pricePerHour: 750, yearsExp: 7,
                icon: "figure.dance", colorName: "pink",
                tagsUk: ["Схуднення", "Нутриціологія", "Жіночий тренінг"],
                tagsEn: ["Weight loss", "Nutrition", "Women's training"]),
        Trainer(id: "t3", nameUk: "Дмитро Бондаренко", nameEn: "Dmytro Bondarenko",
                specialtyUk: "Кросфіт та функціоналка", specialtyEn: "CrossFit & functional",
                bioUk: "Тренер CrossFit Level 2. Функціональні тренування, витривалість, вибухова сила. Готую до змагань і просто роблю людей витривалішими.",
                bioEn: "CrossFit Level 2 coach. Functional training, endurance, explosive power. I prep athletes for competition and simply make people more resilient.",
                rating: 4.8, reviewsCount: 98, pricePerHour: 700, yearsExp: 6,
                icon: "figure.cross.training", colorName: "orange",
                tagsUk: ["Кросфіт", "Витривалість", "HIIT"],
                tagsEn: ["CrossFit", "Endurance", "HIIT"]),
        Trainer(id: "t4", nameUk: "Ірина Мельник", nameEn: "Iryna Melnyk",
                specialtyUk: "Йога та мобільність", specialtyEn: "Yoga & mobility",
                bioUk: "Викладач хатха- та він'яса-йоги. Працюю з гнучкістю, поставою і відновленням після травм. Індивідуальний підхід до кожного тіла.",
                bioEn: "Hatha and vinyasa yoga instructor. I work on flexibility, posture and recovery after injuries. An individual approach for every body.",
                rating: 4.9, reviewsCount: 156, pricePerHour: 600, yearsExp: 10,
                icon: "figure.yoga", colorName: "teal",
                tagsUk: ["Йога", "Розтяжка", "Відновлення"],
                tagsEn: ["Yoga", "Stretching", "Recovery"]),
        Trainer(id: "t5", nameUk: "Андрій Ткаченко", nameEn: "Andrii Tkachenko",
                specialtyUk: "Набір м'язової маси", specialtyEn: "Muscle gain",
                bioUk: "Чемпіон області з бодібілдингу. Спеціалізація — гіпертрофія, періодизація навантажень і харчування на масі без зайвого жиру.",
                bioEn: "Regional bodybuilding champion. Specialising in hypertrophy, load periodisation and bulking nutrition without excess fat.",
                rating: 4.7, reviewsCount: 83, pricePerHour: 850, yearsExp: 8,
                icon: "figure.arms.open", colorName: "red",
                tagsUk: ["Бодібілдинг", "Маса", "Харчування"],
                tagsEn: ["Bodybuilding", "Mass", "Nutrition"]),
        Trainer(id: "t6", nameUk: "Катерина Лисенко", nameEn: "Kateryna Lysenko",
                specialtyUk: "Біг та кардіо", specialtyEn: "Running & cardio",
                bioUk: "Майстер спорту з легкої атлетики, фінішер 12 марафонів. Підготую до вашого першого забігу — від 5 км до марафону.",
                bioEn: "Master of Sport in athletics, finisher of 12 marathons. I'll prepare you for your first race — from 5K to a marathon.",
                rating: 4.8, reviewsCount: 71, pricePerHour: 650, yearsExp: 5,
                icon: "figure.run", colorName: "mint",
                tagsUk: ["Біг", "Марафон", "Витривалість"],
                tagsEn: ["Running", "Marathon", "Endurance"]),
        Trainer(id: "t7", nameUk: "Віктор Романюк", nameEn: "Viktor Romaniuk",
                specialtyUk: "Реабілітація", specialtyEn: "Rehabilitation",
                bioUk: "Фізичний терапевт. Відновлення після травм, робота зі спиною та суглобами, ЛФК. Спочатку здоров'я — потім рекорди.",
                bioEn: "Physical therapist. Recovery after injuries, work on the back and joints, therapeutic exercise. Health first — records later.",
                rating: 5.0, reviewsCount: 189, pricePerHour: 900, yearsExp: 12,
                icon: "figure.mind.and.body", colorName: "indigo",
                tagsUk: ["Реабілітація", "ЛФК", "Спина"],
                tagsEn: ["Rehab", "Therapy", "Back"]),
        Trainer(id: "t8", nameUk: "Софія Гончарук", nameEn: "Sofiia Honcharuk",
                specialtyUk: "Персональний тренінг", specialtyEn: "Personal training",
                bioUk: "Універсальний тренер з міжнародною сертифікацією NASM. Складу збалансовану програму: сила, кардіо, мобільність — усе в правильних пропорціях.",
                bioEn: "All-round trainer with an international NASM certification. I'll build a balanced program: strength, cardio, mobility — all in the right proportions.",
                rating: 4.9, reviewsCount: 142, pricePerHour: 780, yearsExp: 6,
                icon: "figure.mixed.cardio", colorName: "purple",
                tagsUk: ["Універсал", "NASM", "Баланс"],
                tagsEn: ["All-round", "NASM", "Balance"]),
    ]
}
