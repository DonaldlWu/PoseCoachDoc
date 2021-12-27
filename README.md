# PoseCoachDoc 

	                                                                                                    
	    ┌──────────────────────────────────────────────────────────────────────────────────────────────┐
	    │                                       PoseCoach - App                                        │
	    │                                                                                              │
	    │                                         ContentView                                          │
	    │                                                                                              │
	    │     ┌──────────────────────────────────────────────────────────────────────────────────┐     │
	    │     │                                                                                  │     │
	    │     │                                     MainView                                     │     │
	    │     │    ┌───────────────────────────────────────────────────────────────────────┐     │     │
	    │     │    │                                                                       │     │     │
	    │     │    │                                ZStack                                 │     │     │
	    │     │    │                                                                       │     │     │
	    │     │    │       ┌────────────────────────┐     ┌────────────────────────┐       │     │     │
	    │     │    │       │                        │     │     CustomTabView      │       │     │     │
	    │     │    │       │                        │     │                        │       │     │     │
	    │     │    │       │                        │     │   ┌─────────────────┐  │       │     │     │
	    │     │    │       │                        │     │   │    HomeView     │  │       │     │     │
	    │     │    │       │                        │     │   └─────────────────┘  │       │     │     │
	    │     │    │       │        SideView        │     │   ┌─────────────────┐  │       │     │     │
	    │     │    │       │                        │     │   │   CameraView    │  │       │     │     │
	    │     │    │       │                        │     │   └─────────────────┘  │       │     │     │
	    │     │    │       │                        │     │   ┌─────────────────┐  │       │     │     │
	    │     │    │       │                        │     │   │    AboutView    │  │       │     │     │
	    │     │    │       │                        │     │   └─────────────────┘  │       │     │     │
	    │     │    │       │                        │     │                        │       │     │     │
	    │     │    │       └────────────────────────┘     └────────────────────────┘       │     │     │
	    │     │    └───────────────────────────────────────────────────────────────────────┘     │     │
	    │     │                                                                                  │     │
	    │     └──────────────────────────────────────────────────────────────────────────────────┘     │
	    │                                                                                              │
	    └──────────────────────────────────────────────────────────────────────────────────────────────┘


Use Cases
---

### Load History Log from remote

#### Data

- URL

#### Primary course(happy path)

1. Execute "Load History Log" command with URL.
2. System get data from the URL.
3. System delivers History Log.


#### Invalid data - error course(sad path)

1. System delivers invalid data error.

#### No connectivity - error course(sad path)

1. System delivers connectivity error.

## Model Spec

| Property       | Type               |
|----------------|--------------------|
| `title`        | `String`           |
| `description`  | `String`(optional) |
| `timestamp`    | `String`           |


Payload
---

```
GET / log

200 RESPONSE

{
	"logs": [
		{
			"title": "log title here",
			"description": "log infomation",
			"timestamp": "2021-01-01T23:28:56.782Z",
		},
		{
			"title": "log title here",
			"timestamp": "2021-01-01T23:28:56.782Z",
		},
		{
			"title": "log title here",
			"description": "log infomation",
			"timestamp": "2021-01-01T23:28:56.782Z",
		}
		...
	]
}
```



