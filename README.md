## ActivityViewController
This framework provides a controller that can handle loading, managing, and transitioning between storyboards or provided UIViewControllers using controller containment. Removing transitioning delegate code from controllers and allowing you to throw inactive controllers away are the frameworks main features.

#### Installation
Using [Carthage](https://github.com/Carthage/Carthage) add
```shell
github "bromas/ActivityViewController"
```
to your Cartfile

Using [CocoaPods](https://guides.cocoapods.org/using/index.html) add
```ruby
use_frameworks!
pod 'ActivityViewController', '~> 1.0'
```
to your Podfile

### Generate, Configure, Display, Dispose.

A basic useage of ActivityViewController is registering generator blocks to construct and configure controllers before adding it as a child controller, and specifiying an initialActivityIdentifier. 

```swift
func configureEmbeddedActivities(activities: ActivityViewController) {
    activities.registerGenerator("first") { [unowned self] () -> UIViewController in
      let childController = FirstController()
      ConfigurationManager.sharedInstance.configureFirstController(childController)
      return childController
    }
    activities.registerGenerator("second") { [unowned self] () -> UIViewController in
      let childController = SecondController()
      ConfigurationManager.sharedInstance.configureSecondController(childController)
      return childController
    }
    activities.initialActivityIdentifier = "first"
  }
```

After registering the generators above, this code will perform the SpringSlideAnimator animated transitioning to switch between the controllers and deallocate the one that is not currently displayed.

``` swift
func swapController() {
    self.swapButton.enabled = false
    switch activeActivity {
    case "first":
      var operation = ActivityOperation(identifier: "second", animator: SpringSlideAnimator(direction: .Right))
      operation.completionBlock = { [unowned self] in
        self.swapButton.enabled = true
        self.activities.flushInactiveActivitiesForIdentifier("first")
        return
      }
      activities.performActivityOperation(operation)
      activeActivity = "second"
    default:
      var operation = ActivityOperation(identifier: "first", animator: SpringSlideAnimator(direction: .Left))
      operation.completionBlock = { [unowned self] in
        self.swapButton.enabled = true
        self.activities.flushInactiveActivitiesForIdentifier("second")
        return
      }
      activities.performActivityOperation(operation)
      activeActivity = "first"
    }
  }
```

### Storyboards Are Generators Too.

You do not have to register generators if you let your storyboards represent your String -> UIViewController conversion. 

Specifically, an activity operation searches for a controller on this path.

inactive but already constructed -> generators for key -> storyboards of the same name

For example, this is a valid operation if you have a storyboard called 'locations' and want to display its initial view controller.

```swift
var operation = ActivityOperation(identifier: "locations", animator: SpringSlideAnimator(direction: .Right))
      activities.performActivityOperation(operation)
```

### Using ActivityOperations

#### Transitioning

The ActivitiyOperation has 3 initializers for specifying transition animations.

Unanimated transitions:

```swift
ActivityOperation(identifier: "Authentication")
```

UIViewAnimationOptions:

```swift
ActivityOperation(identifier: "Authentication", animationType: .TransitionCurlUp, duration: 0.5)
```

UIViewControllerAnimatedTransitionings:

```swift
ActivityOperation(identifier: "Authentication", animator: ShrinkAnimator())
```

#### Persistance

Inactive activities are stored in the ActivityViewController that presented them by key ('activityIdentifier') and in the order of their last presentation. Calling to switch to an activity key that has already been presented will simply redisplay the same controllers. You can, however, flush out the view controllers which reside under an Activity Identifier if you want to launch a fresh version of that storyboard/UIViewController on the next presentation of that key

```swift
activitiesController.flushInactiveActivitiesForIdentifier(...)
```

or use the '.New' presentation 'rule' exposed on the ActivityOperation.

```swift
ActivityOperation(rule: .New, identifier: "Authentication", animator: ShrinkAnimator()).execute()
```

#### Make ActivityViewController Your RootController

Set the class type of your initial view controller in the applications main storyboard to your custom subclass of ActivityViewController and set the initialActivityIdentifier as a User Defined Runtime Attribute to the name of the first storyboard you would like to load. 

In this special case, you can simply call execute() on an ActivityOperation and it will handle passing itself on to the root ActivityViewController.

#### Examples

The included sample project, and my FrameworksPlayground repo on github show some example useage.
