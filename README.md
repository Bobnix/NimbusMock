#NimbusMock

A fast and flexable mocking framework for Salesforce Apex

##Version
0.0.1

This is the first release of NimbusMock. The api is **NOT** frozen. In fact, there is an almost 100% chance of changing once or twice before I increment the minor version.

##Class Setup in your Application
Before you can even hope to mock anything, there is a certian way to go about setting up your classes. The service classes must be setup with an interface. The point of the mock will be to override the default functionality with the mock methods. For any classes that are going to use these mocks, they must be setup so that the mocks can either be set in the constructor or a setter.

##How to Mock
The first step, assuming your classes are all ready, is to make your mocks. In `MockFactory.cls`, create an inner class that extends NimbusMock and implements your interface. Your methods will simply call `getCall` with a unique name for that call in that class and an object array of your parameters. The following is a references for how to mock your calls:

```java
public class MockFactory {
	public class MockService extends NimbusMock implements ServiceInterface{
        public String methodName(String parmeter){
            return (String)getCall('methodName', new List<Object>{parmeter});
        }
    }
}
```

##Using your Mocks
Creating an instance of your mock is as easy as any regular class. For example:

```java
ServiceInterface mock = new MockFactory.MockService();
```

From there, you need to tell the mock what to return or throw when a call is made with some combination of parameters. The base is the same in both cases, calling the `when` static method on NimbusMock and pass it the call to the mock method with the parameters you expect. After that you either chain `thenReturn` or `thenThrow` depending on what you want it to do. When put together, it looks something like this:

```javascript
NimbusMock.when(mock.methodOne('value')).thenReturn('other value');
NimbusMock.when(mock.methodTwo('other value')).thenThrow(New CustomException());
```

##TODO
* A generator for the mocks. I plan on writing this in apex and letting the devloper write up a script calling it with a list of classes they want mocked
* The ability to set how many times the same call can be made and to see how many times a call is used after the fact
* Mocking classes without interfaces. This isn't that hard, I just need to settle on how I want to go about it

##Change Log
This is the first version, everything has changed
