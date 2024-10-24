
# LilyPath

## IMPORTANT: HOW TO RUN

Our app heavily relies on HealthKit tracking data, which requires access to real-time health metrics such as steps, distance, and other activity data collected by your iPhone.

### Running in Simulator:
The iPhone simulator has limited support for HealthKit and does not provide real health data for tracking. While the app can run in the simulator, it will not be able to access actual step counts, distance data, or other health metrics. As a result, key features of the app, such as tracking daily steps and growing plants based on fitness data, will not function as intended.

### Please read: https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device

### Running on a Physical Device:
To fully experience the app’s features and functionality:
1. **Connect Your iPhone to Your MacBook**: Plug in your iPhone and select your device as the target to run the app.
2. **Run the App on Your iPhone**: Run the app directly on your physical device to access real-time health data from HealthKit.
3. **Grant HealthKit Permissions**: Upon the first launch, you will be prompted to grant HealthKit access. Make sure to:
    - Accept all Health-related access requests.
    - Grant permission for the app to access activity data like steps, distance, calories, and other fitness metrics.

### Troubleshooting:
- If HealthKit data is not displaying, verify that HealthKit permissions have been enabled by going to:
  - **Settings > Health > Data Access & Devices** and ensuring that your app has permission to access the relevant health data.
- Ensure that your iPhone has HealthKit tracking enabled and that health data is being recorded by the device.

By following these steps, the app will be able to access real-time health data from HealthKit, allowing you to grow plants and track your progress based on your daily fitness activity.


## Textual Description

LilyPath is designed to motivate users to stay active throughout their day by transforming physical movement into a fun and rewarding experience. The app’s core concept allows users to grow virtual plants by tracking the number of steps they take. Steps can be converted into “water points,” which nourish and help the plants grow. LilyPath is divided into three main sections: Home, Garden, and Stats, each of which provides users with unique ways to engage with their fitness progress and achievements.

## Home Tab

The Home tab is the primary feature where users interact with the plant they are currently growing. It serves as both a visual representation of their fitness journey and a gamified incentive to stay active.

- **Water Points**: Each step taken by the user is converted into 1 water point. These points act as the currency for watering and growing the plant. Users can view their total available water points directly in this tab. The more steps taken, the more water points they accumulate, encouraging ongoing activity throughout the day.
  
- **Growth Stages**: The growth of the plant is split into distinct stages, each marked by a transformation in the plant’s appearance. To advance the plant to its next stage, users must water the plant by spending 1,000 water points at a time. After 10 waterings (10,000 steps), the plant advances to its next growth stage. These visual changes offer immediate feedback to users about their progress.
  
- **Missed Watering**: Consistency is key. If users fail to water their plant for a day, it will regress to its previous growth stage, representing a temporary setback. If the plant is at its first stage and no watering occurs, it will wilt, symbolizing the importance of daily activity. Users are notified of any missed watering and given encouragement to re-engage.

- **Rewards**: Upon successfully completing a plant's full growth cycle, users are rewarded with 1 gem. Gems serve as in-game currency to buy a variety of plants, offering additional incentives for staying active. A completed growth cycle provides not only visual satisfaction but also tangible rewards that can be used elsewhere in the app.

### Plant Sub-View: Daily Tasks

Within the Plant tab, users have access to a list of fitness Daily Tasks that offer additional opportunities to earn rewards (i.e., gems). These tasks encourage users to vary their physical activity and challenge themselves. The tasks range in difficulty and duration, providing something for everyone regardless of their fitness level. Some task examples include:

- Climbing 10 flights of stairs
- Walking 10,000 steps in a day
- Standing for 3-5 hours

Completing each task rewards the user with 3 gems, providing motivation for continuous engagement.

### Plant Sub-View: Buying Plants

Gems earned from completing the growth cycle of a plant or from Daily Tasks can be used to purchase new plant species. The ability to purchase new plants allows for personalization and variety within the user’s fitness journey. Different species come with their own unique visual appeal, enabling users to collect and grow a diverse range of plants. This customization adds a new layer to the user experience, encouraging long-term engagement as they build their garden.

## Garden Tab

The Garden tab functions as a personal gallery and a visual archive of the user’s fitness journey. It not only provides a sense of accomplishment by displaying all plants grown, but also where users can revisit their past successes.

- **Plant Collection**: This view allows users to browse all the plants they’ve grown, each representing a completed cycle of activity.
  
- **Detailed Stats**: Tapping on any plant within the collection opens a detailed view of its history and growth process. Users can access information such as:

  - **Plant Date**: When the plant was first started.
  - **Completion Date**: When the plant fully matured.
  - **Species**: A description of the plant species and its unique characteristics.
  - **Growth Status**: The percentage of completed plant growth.
  - **Steps Left**: The number of steps left until the user completes the plant.
  - **Level**: The level (current stage) the plant is at.

- **Switching Plants**: Users are not confined to growing a single plant. By selecting any plant from their collection, users can switch which plant is currently growing.

- **Current Plant**: A dedicated section within the Garden tab displays the current plant the user is growing, along with its associated stats, for easy access and motivation.

## Statistics Tab

The Stats tab offers a comprehensive overview of the user’s fitness data, allowing them to see how their physical activity has contributed to their plant-growing journey. This section integrates directly with Apple HealthKit, making use of its data to track the user’s steps, flights climbed, and more.

- **Fitness Data**: The Stats tab aggregates fitness data across different time frames (weekly, monthly, yearly), such as total steps, flights climbed, etc., and presents it in easy-to-understand graphs.

## Citations

- “Cornucopia” by MizuJakkaru et al.  
  Downloaded from [“Cornucopia - More Flowers” on Nexus Mods](https://www.nexusmods.com/stardewvalley/mods/20290)  
  License: Assets used with permission, credit given to MizuJakkaru
