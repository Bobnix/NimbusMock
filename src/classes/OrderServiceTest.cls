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

@isTest
public class OrderServiceTest{
    private static OrderService service;
    private static PaymentInterface mock;
    
    public static void beforeTest(){
        mock = new MockFactory.MockPaymentService();
        service = new OrderService();
        service.payment = mock;
    }
    
    public static testmethod void testProcessOrderPayment(){
        beforeTest();
        NimbusMock.when(mock.getAuthCode(Matcher.anyDate)).thenReturn('123456');
        NimbusMock.when(mock.processPayment('123456')).thenReturn('Mock service successfully processed your payment!');
    
        String retVal = service.processOrderPayment();
        System.assertEquals('Mock service successfully processed your payment!', retVal);
    }
    
    public static testmethod void testProcessOrderPaymentBadAuth(){
        beforeTest();
        NimbusMock.when(mock.getAuthCode(Matcher.anyDate)).thenReturn(null);
        
        try{
            String retVal = service.processOrderPayment();
            System.assert(false, 'Exception not thrown');
        } catch (BadAuthException e){
            //Expected
        }
    }
    
    public static testmethod void testProcessOrderPaymentTimeout(){
        beforeTest();
        NimbusMock.when(mock.getAuthCode(Matcher.anyDate)).thenReturn('123456');
        NimbusMock.when(mock.processPayment('123456')).thenThrow(New PaymentTimeoutException('Payment timeout'));
    
        String retVal = service.processOrderPayment();
        System.assertEquals('Failed to process. Reason: Payment timeout', retVal);
    }
}