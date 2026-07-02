import XCTest

final class FitTrackUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func snapshot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Completes onboarding when the app is launched for the first time.
    private func passOnboardingIfNeeded() {
        let nameField = app.textFields["Ваше ім'я"]
        guard nameField.waitForExistence(timeout: 3) else { return }
        nameField.tap()
        nameField.typeText("Тест")
        for _ in 0..<4 {
            app.buttons["Далі"].tap()
        }
        snapshot("onboarding-result")
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Почати'")).firstMatch.tap()
    }

    func testMainFlows() {
        passOnboardingIfNeeded()

        // MARK: Dashboard
        XCTAssertTrue(app.tabBars.buttons["Головна"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Вода"].exists)
        app.buttons["+250 мл"].tap()
        snapshot("01-dashboard")

        // MARK: Workouts: programs, detail, active session
        app.tabBars.buttons["Тренування"].tap()
        XCTAssertTrue(app.staticTexts["Full Body для початківців"].waitForExistence(timeout: 3))
        snapshot("02-workouts")

        app.staticTexts["Full Body для початківців"].tap()
        XCTAssertTrue(app.buttons["Почати тренування"].waitForExistence(timeout: 3))
        snapshot("03-template-detail")

        app.buttons["Почати тренування"].tap()
        XCTAssertTrue(app.staticTexts["Підходи"].waitForExistence(timeout: 3))
        // Mark the first set done; the rest timer should appear.
        app.buttons.matching(identifier: "circle").firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Відпочинок"].waitForExistence(timeout: 2))
        snapshot("04-active-workout")
        app.buttons["Пропустити"].tap()
        // Finish and save.
        app.buttons["Завершити"].tap()
        app.buttons["Зберегти тренування"].tap()
        // Wait for the active session screen to close, then return to the list.
        XCTAssertTrue(app.buttons["Почати тренування"].waitForExistence(timeout: 5))
        app.buttons["BackButton"].tap()

        // History should contain the saved session.
        XCTAssertTrue(app.buttons["Історія"].waitForExistence(timeout: 5))
        app.buttons["Історія"].tap()
        XCTAssertTrue(app.staticTexts["Full Body для початківців"].waitForExistence(timeout: 3))
        snapshot("05-history")

        // Exercise library.
        app.buttons["books.vertical"].tap()
        XCTAssertTrue(app.staticTexts["Жим штанги лежачи"].waitForExistence(timeout: 3))
        snapshot("06-exercise-library")
        app.navigationBars.buttons.firstMatch.tap()

        // MARK: Nutrition: add food
        app.tabBars.buttons["Харчування"].tap()
        XCTAssertTrue(app.staticTexts["Сніданок"].waitForExistence(timeout: 3))
        snapshot("07-nutrition")

        app.buttons["plus.circle.fill"].firstMatch.tap()
        // Use a visible item from the top of the list because List does not instantiate off-screen rows.
        let foodRow = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Куряче філе'")).firstMatch
        XCTAssertTrue(foodRow.waitForExistence(timeout: 3))
        foodRow.tap()
        XCTAssertTrue(app.buttons["Додати до «Сніданок»"].waitForExistence(timeout: 3))
        snapshot("08-portion")
        app.buttons["Додати до «Сніданок»"].tap()
        XCTAssertTrue(app.staticTexts["Куряче філе (варене)"].waitForExistence(timeout: 3))

        // MARK: Stats
        app.tabBars.buttons["Статистика"].tap()
        XCTAssertTrue(app.staticTexts["Вага"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Індекс маси тіла"].exists)
        snapshot("09-stats")

        // MARK: Profile
        app.tabBars.buttons["Головна"].tap()
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Досягнення"].waitForExistence(timeout: 3))
        snapshot("10-profile")
    }
}
