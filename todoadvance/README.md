# Flutter Todo Application

This is a simple yet functional Todo application built using Flutter. The application allows users to manage their tasks effectively. The main features of the application are:

1. **Task Submission**: Users can add new tasks to their todo list. Each task requires a title, and optionally, a description or notes about the task.

2. **Task Editing**: Users can edit the details of existing tasks. This includes changing the title, description, or status of the task.

3. **Task Deletion**: Users can remove tasks from their list once they are completed or no longer needed.

4. **Local Storage**: All tasks are stored locally on the user's device. This ensures that the tasks persist even when the app is closed or the device is restarted.

The application uses the `sqflite` package for local data storage. Sqflite is a Flutter plugin for SQLite, a self-contained, high-reliability, embedded, SQL database engine. Sqflite allows you to access and manipulate databases, and it supports transactions and batched updates for complex queries.

Please note that while `sqflite` is great for storing larger amounts of data, like a large number of tasks, or complex data types like nested lists and maps, if you plan to store small amounts of simple data, a key-value store like `shared_preferences` might be more suitable.

