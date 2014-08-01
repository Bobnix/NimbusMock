/*
Copyright 2014 Bob Roberts

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

public abstract class NimbusMock{
    private Map<String, List<Invocation>> invocations = new Map<String, List<Invocation>>();
    private static Invocation lastInvocation;

    public static Invocation when(Object discard){
        return lastInvocation;
    }
    
    protected Object getCall(String methodName, List<Object> parameters){
        if(!invocations.containsKey(methodName)){
            invocations.put(methodName, new List<Invocation>());
            lastInvocation = new Invocation(parameters);
            invocations.get(methodName).add(lastInvocation);
        }
        
        List<Invocation> invocationList = invocations.get(methodName);
        Invocation match = null;
        Boolean notFound = false;
        for(Invocation topInvocation : invocationList){
            System.assertEquals(topInvocation.parameters.size(), parameters.size());
            for(Integer i = 0; i < topInvocation.parameters.size(); i++){
                if(topInvocation.parameters[i] != null && (topInvocation.parameters[i] === Matcher.anyDate || topInvocation.parameters[i] === Matcher.anyDatetime)){
                    continue;
                }
                if(topInvocation.parameters[i] != parameters[i]){
                    notFound = true;
                    break;
                }
            }
            if (notFound){
                lastInvocation = new Invocation(parameters);
                invocations.get(methodName).add(lastInvocation);
            } else {
                match = topInvocation;
            }
        }
        
        if(match != null){
            if(match.exceptionValue != null){
                throw match.exceptionValue;
            }
            
            return match.returnValue;
        } else {
            return null;
        }
        
    }
    
    public class Invocation{
        private List<Object> parameters;
        private Object returnValue;
        private Exception exceptionValue;

        
        public Invocation(List<Object> parameters){
            this.parameters = parameters;
        }

        public void thenreturn(Object returnValue){
            this.returnValue = returnValue;
        }

        public void thenThrow(Exception e){
            exceptionValue = e;
        }
    }
}