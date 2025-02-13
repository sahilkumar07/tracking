# Flutter Application with FCM and Firebase Integration

## Overview

This Flutter application provides a user interface with the following features:
- **Login Screen**: Allows users to sign in using Firebase Authentication.
- **Signup Screen**: Allows users to create an account.
- **Dashboard Screen**: Displays user details such as name, email, phone number, and application status.
- **Application Status Screen**: Allows users to track the progress of their application, showing various stages such as document submission, interview scheduling, and final decision.
- **FCM Notifications**: Real-time push notifications are handled using Firebase Cloud Messaging (FCM). Notifications are shown when a new message is received.

## Technologies Used

- **Flutter**: Framework for building cross-platform mobile applications.
- **Firebase**:
  - Firebase Authentication: Used for user authentication (login and signup).
  - Firebase Firestore: Stores user data and application statuses.
  - Firebase Cloud Messaging (FCM): Handles push notifications to inform users about updates.
- **Flutter Local Notifications**: Manages local notifications for the user when an FCM message is received.
  
## Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/sahilkumar07/tracking
  
