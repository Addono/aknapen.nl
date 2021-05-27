+++
title = "Collect Emails from NextJS Form in HubSpot"
description = "Automatically store responses to an email collection form on your NextJS website in HubSpot."
tags = [
    "NextJS",
    "HubSpot",
    "NodeJS",
    "Serverless",
    "Development"
]
date = "2021-05-27"
categories = [
    "Development",
    "Technology"
]

+++

# Collect Emails from NextJS Form in HubSpot

HubSpot is an awesome platform to centrally track all the contacts your company is doing business with.
At [ClaimR](https://claimr.tools) we have been using HubSpot with great success, as it allows all our team members to have a single source of truth.

During the last few weeks I have been working on our renewed website.
NextJS is a no-brainer at this point, as it is an amazing framework which spits out static HTML wherever it can - perfect for fast loading landing pages - while also giving you the flexibility to mix in some dynamic content and other server side logic.
All in one simple framework, pretty neat right?

For this new website we wanted to have a simple form where our users can leave their email in case they are interested in hearing more of us.
In this post I will show you how we in the end implemented this form, such that the form submission is directly stored in HubSpot, such that our single-source of truth stays the single source.

## Create the Form

First, we create our form component. 
For this, we will be using plain React and the `axios-hooks` library to send the content of our form with.
In case you haven't installed it yet, first run:
```bash
# For npm
npm install axios axios-hooks

# For Yarn
yarn add axios axios-hooks
``` 

Then the component is just a simple form to which we supply a callback to Axios to make the webrequest with the form's data.

```tsx
import { useEffect, useState } from "react"
import useAxios from "axios-hooks"

const EmailSignupForm = () => {
  const [email, setEmail] = useState("")
  const [pageUri, setPageUri] = useState<string>()

  const [{ data, loading, error }, refetch] = useAxios(
    {
      url: "/api/emailSignup",
      method: "POST",
      data: { email, pageUri },
    },
    {
      manual: true,
    }
  )

  // Clear the form on successful submitting it
  useEffect(() => {
    if (data?.success === true && !loading) {
      setEmail("")
    }
  }, [data?.success, loading])

  // Get the url the user is currently visiting.
  // Optional, but enriches the data we have in HubSpot.
  useEffect(() => {
    setPageUri(window.location.href)
  })

  return (
    <>
      <input
        type={"email"}
        placeholder={"mail@example.com"}
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <button
        type={"submit"}
        onClick={() => refetch()}
        disabled={loading}
      >
        Signup
      </button>
    </>
  )
}
```

## Creating our API Endpoint

You might have noticed by now that our `EmailSignupComponent` tries to send the content of the form to the `/api/emailSignup` endpoint.
Our next step is to create this endpoint and create a truly functional form.

First, go to HubSpot and create a new form in the UI with just one field for the email.
Make sure to remove any Captchas or other required fields, as they will interfere with submitting our form later on.
In the address bar you can find the portal ID and form GUID, note these down as you will need to add them later.

We will be using the [HubSpot Form AP](https://legacydocs.hubspot.com/docs/methods/forms/submit_form_v3_authentication) to directly submit our form entries to HubSpot.
Yes, HubSpot advocates for alternative approaches, such as their "Non-HubSpot Forms", but in this way we stay in control of the form styling ourselves without needing to add the HubSpot tracking code to our website.

The following class is the complete serverless function which will forward the data to HubSpot.
Alternatively, you can also use the unauthenticated API and directly sent the form submissions there, with the downside that the GUID of the form becomes public and you might have to filter out a lot of spam.
The upside would be that this eliminates the need for you managing any backend logic, allowing your static site to be trully static.

```ts
import type { NextApiRequest, NextApiResponse } from "next"
import axios from "axios"

const HUBSPOT_API_KEY = process.env.HUBSPOT_API_KEY
const HUBSPOT_PORTAL_ID = "62515" // Replace this
const HUBSPOT_FORM_GUID = "fcc69886-915b-4fef-b35f-27850ef461e1" // Replace this

type Response = {
  success: boolean
  email?: string
}

export default async (req: NextApiRequest, res: NextApiResponse<Response>) => {
  const { email, pageUri } = req.body

  if (typeof email !== "string") {
    return res.status(400).json({ success: false })
  }

  try {
    const response = await axios({
      method: "POST",
      url: `https://api.hsforms.com/submissions/v3/integration/secure/submit/${HUBSPOT_PORTAL_ID}/${HUBSPOT_FORM_GUID}\?hapikey\=${HUBSPOT_API_KEY}`,
      data: {
        fields: [{ name: "email", value: email }],
        context: { pageUri },
      },
      headers: { "Content-Type": "application/json" },
    })
  } catch (error) {
    return res.status(500).json({ success: false })
  }

  res.status(200).json({ success: true, email })
}
```

_Note that the HubSpot API key is set as an environment variable `HUBSPOT_API_KEY`. So make sure that that is available in the environment running this function._

This is pretty much all there's to it.
In the end, we have a quite simple solution which still allows us to style the form however we want.
I left my specific styling out, but when the new website is live I will add link to show off the purty end-result.
