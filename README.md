## ActivityViewController
This framework provides a controller that can handle loading, managing, and transitioning between storyboards or provided UIViewControllers using controller containment. Removing transitioning delegate code from controllers and allowing you to throw inactive controllers away are the frameworks main features.

#### Installation
Using [Carthage](https://github.com/Carthage/Carthage) add
```shell
github "bromas/ActivityViewController"
```
to your Cartfile

Using [Cocoapods](https://guides.cocoapods.org/using/index.html) add
```ruby
use_frameworks!
pod 'ActivityViewController', '~> 1.0'
```
to your Podfile

### Getting Started

After including the framework in your project, set the class type of your initial view controller in the applications main storyboard to ActivityViewController. To display an initial activity/storyboard, set the initialActivityIdentifier as a User Defined Runtime Attribute to the name of the first storyboard you would like to load. (Look at the Identity Inspector of the Main.storyboard in the sample application if that doesnt make sense.)

'Loading an activity' basically means searching for a storyboard of the same name and loading it's initial view controller.

To test out how this works make 2 new storyboards beyond the Main.storyboard and set the name of one of those as the initialActivityIdentifier as suggested above. Create and execute an ActivityOperation to transition to the second storyboard.

```swift
ActivityOperation(identifier: "Second", animationType: .TransitionCurlUp, duration: 0.4).execute()
```

### Using The ActivityViewController

#### Configuring Activities

If you subclass ActivityViewController and override prepareForActivity(identifier: String, controller: UIViewController) you can handle any needed initialization/configuration. (only runs each time a new controller is created, not on redisplay.)

#### Configuring Generators

You can add closures that generate UIViewControllers for specific keys if you don't want/need to construct a storyboard.

```swift
activitiesController.registerGenerator("Generated") { 
  return GeneratedController() 
}
```

#### Persistance

Inactive activities are stored by key ('activityIdentifier') and in the order of their last presentation. Calling to switch to an activity key that has already been presented will simply redisplay the same controllers. You can, however, flush out the view controllers which reside under an Activity Identifier if you want to launch a fresh version of that storyboard/UIViewController on the next presentation of that key

```swift
activitiesController.flushInactiveActivitiesForIdentifier(...)
```

or use the '.New' presentation 'rule' exposed on the ActivityOperation.

```swift
ActivityOperation(rule: .New, identifier: "Authentication", animator: ShrinkAnimator()).execute()
```

#### Transitions

Transitioning between activities is encapsulated in the ActivityOperation struct. These can be executed by calling the execute() method on the operation (this requires and will perform the operation on an ActivityViewController that is the root controller of your app) or by calling the performActivityOperation instance method on an ActivityViewController you have embedded elsewhere in your app. 

```swift
activityViewController.performActivityOperation(operation)
```

The ActivitiyOperation has 3 initializers for specifying transition animations.

One for Unanimated transitions:

```swift
ActivityOperation(identifier: "Authentication").execute()
```

One for UIViewAnimationOptions:

```swift
ActivityOperation(identifier: "Authentication", animationType: .TransitionCurlUp, duration: 0.5).execute()
```

And one for UIViewControllerAnimatedTransitionings:

```swift
ActivityOperation(identifier: "Authentication", animator: ShrinkAnimator()).execute()
```


#### Examples

The included sample project, and my FrameworksPlayground repo here in github show some example useage.
