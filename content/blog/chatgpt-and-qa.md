---
title: "Chatgpt and QA"
date: 2023-01-17T10:54:36-06:00
draft: false
description: "How ChatGPT has changed the way I work."
---

# ChatGPT. Speeding up every part of the SDLC
If you read this blog, then you have heard of ChatGPT. AI for the masses. You know, a lot of people are saying it's the end of software
development as we know it, but are they right? I think it's just another tool to help speed up development. I don't think we are at the 
location where jobs can be fully replaced. Yet... So how has it increased the SDLC speed. To start doing small simple POC projects
has become really easy with this new tool. Not just that, but the context that ChatGPT has is amazing. You can literally use it as a more
Junior or Senior Developer, depending on your own personal knowledge. If you know how to code, you will most likely use it to write up quick 
scripts that you know how to integrate. If you don't know how to code, or you are just starting, it will be able to guide you through a full SaaS setup. 

This is the magic behind it. You must know some coding and understand some basics for you to be able to tell it how to take some code and arramge it. Or give it well known context so that it can continue the basic items it gave you. 

I wanted to do a small experiement with ChatGPT and see how it could help me be more efficient. So I gave it the following piece of code and asked for it to lint it and comment it. 

```typescript
import { test, expect, APIRequestContext, request } from '@playwright/test';
export default class Organization{
    readonly reqContext: APIRequestContext;
    readonly errorBlankName: any;
    
    readonly limit: Number;
    readonly offset: Number;
    readonly sort: String;
    readonly organizationId: String;

    statusResponse: number;
    callResponse: any;

    constructor (request: APIRequestContext, limit: Number, offset: Number, sort: String, organizationId: String)
    {
        this.reqContext = request;
        this.limit = limit;
        this.offset = offset;
        this.sort = sort;
        this.organizationId = organizationId;
    }

    public async getMessage(token: any)
    {
        await test.step(`I can make a GET call to organization`,async () => {
            console.log("Request sending: " + `${process.env.baseAPIURL}/v2/organization/${this.organizationId}/departments?limit=${this.limit}&offset=${this.offset}&sort=${this.sort}`)
            console.log("Token: " + token);
            const response = await this.reqContext.get(`${process.env.baseAPIURL}/v2/organization/${this.organizationId}/departments?limit=${this.limit}&offset=${this.offset}&sort=${this.sort}`, {
                'headers':{
                    'Authorization': `Bearer ${token}`
                }
            })
            this.statusResponse = response.status();
            this.callResponse = await response.json();
        });
    }

    public async StatusResponseCodeIs(status: any)
    {
        await test.step(`The organization status is ${status}`, async() =>{
            expect(this.statusResponse, 'Expected Status').toBe(status);
        });
    }

    public async OrganizationBodyIsValid()
    {
        await test.step(`The Organization JSON Body is validated`, async() =>{
            let jsonObj = this.callResponse as IOrganization;
            console.log(jsonObj);
            expect(typeof jsonObj.nextPage === 'string' || typeof jsonObj.nextPage === null);
            expect(typeof jsonObj.offset === 'number');
            expect(typeof jsonObj.limit === 'number');
            expect(typeof jsonObj.totalCount === 'number');
            expect(typeof jsonObj.data[0].userCount === 'string');
            expect(typeof jsonObj.data[0].clientCount === 'string');
            expect(typeof jsonObj.data[0].id === 'string');
            expect(typeof jsonObj.data[0].name === 'string');
        });
    }

    public async OrganizationBodyIsUndefined()
    {
        await test.step(`The Organization JSON Body is undefined`, async() =>{
            expect(this.callResponse.data).toBe(undefined);
        })
    }
    
}

export interface IOrgInnerData {
    id: string;
    name: string;
    userCount: string;
    clientCount: string;
}
export interface IOrganization {
    totalCount: number;
    offset: number;
    limit: number;
    data: IOrgInnerData[];
    nextPage: string;
}

```


Sure enough it printed comments with context on the code I wrote. In the future this might be able to get placed in a pipeline where the dev pushes and ChatGPT can now update comments and lint and maybe even optimize? 

Here is the code it gave me back. 


```typescript

import { test, expect, APIRequestContext, request } from '@playwright/test';

// Organization class representing the organization's API calls
export default class Organization {
    // Request context, which holds the request function
    readonly reqContext: APIRequestContext;
    // Error message for blank name
    readonly errorBlankName: any;
    
    // Query parameters
    readonly limit: number;
    readonly offset: number;
    readonly sort: string;
    readonly organizationId: string;

    // Response properties
    statusResponse: number;
    callResponse: any;

    // Constructor
    constructor(request: APIRequestContext, limit: number, offset: number, sort: string, organizationId: string) {
        this.reqContext = request;
        this.limit = limit;
        this.offset = offset;
        this.sort = sort;
        this.organizationId = organizationId;
    }

    /**
     * Get message by making a GET call to the organization endpoint
     * @param token - The token for the request
     */
    public async getMessage(token: any) {
        await test.step(`I can make a GET call to organization`, async () => {
            console.log("Request sending: " + `${process.env.baseAPIURL}/v2/organization/${this.organizationId}/departments?limit=${this.limit}&offset=${this.offset}&sort=${this.sort}`);
            console.log("Token: " + token);
            const response = await this.reqContext.get(`${process.env.baseAPIURL}/v2/organization/${this.organizationId}/departments?limit=${this.limit}&offset=${this.offset}&sort=${this.sort}`, {
                headers: {
                    'Authorization': `Bearer ${token}`
                }
            });
            this.statusResponse = response.status();
            this.callResponse = await response.json();
        });
    }

    /**
     * Asserts that the response status code is the expected one
     * @param status - The expected status code
     */
    public async StatusResponseCodeIs(status: any) {
        await test.step(`The organization status is ${status}`, async () => {
            expect(this.statusResponse, 'Expected Status').toBe(status);
        });
    }

    /**
     * Asserts that the organization's body is valid
     */
    public async OrganizationBodyIsValid() {
        await test.step(`The Organization JSON Body is validated`, async () => {
            let jsonObj = this.callResponse as IOrganization;
            console.log(jsonObj);
            expect(typeof jsonObj.nextPage === 'string' || typeof jsonObj.nextPage === null);
            expect(typeof jsonObj.offset === 'number');
            expect(typeof jsonObj.limit === 'number');
            expect(typeof jsonObj.totalCount === 'number');
            expect(typeof jsonObj.data[0].userCount === 'string');
            expect(typeof jsonObj.data[0].clientCount === 'string');
            expect(typeof jsonObj.data[0].id === 'string');
            expect(typeof jsonObj.data[0].name === 'string');
        });
    }

    /**
     * Asserts that the organization's body is undefined
     */
    public async OrganizationBodyIsUndefined() {
        await test.step(`The Organization JSON Body is undefined`, async () => {
            expect(this.callResponse.data).toBe(undefined);
        })
    }
}

/**
 * Organization Interface for body response inner data
 */ 
export interface IOrgInnerData {
    id: string;
    name: string;
    userCount: string;
    clientCount: string;
}

/**
 * Organization Interface for body response
 */ 
export interface IOrganization {
    totalCount: number;
    offset: number;
    limit: number;
    data: IOrgInnerData[];
    nextPage: string;
}

```

Pretty cool! 
Altough, I really wanted to see if it could optimize this. The server became overloaded with all the people using it. So I opted to leave it here. I did take that code and moved it over into my repo since it had comments. :) 

So this got me thinking if something like this might be possible. 

```
                +----------+
                |          |
                |  ChatGPT |
                |          |
                +----^-+---+
                     | |
                     | |
+---------+     +----+-v---+   +---------+
|         +----->          |   |Deployed |
|  DEV    |     |   Git    +-->|Optimized|
|         <-----+          |   |Code     |
+---------+     +----------+   +---------+
```
Could you get a little service looking at Git and as code goes in ChatGPT would just optimize it and comment it if missing. This would require some decent CI in order to not break what's on git. 

*2023-01-17T10:54:36-06:00

