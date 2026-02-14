<img width="1280" height="640" alt="img" src="https://github.com/user-attachments/assets/8631567c-b7d4-4626-b76c-e525a5e520b7" />
PublicPulse
Basic Details

Team Name: Tofeechu
Team Members:

Krishna P:LBSITW
Navya J:LBSITW

Hosted Project Link:
[[Flutter Web App URL or APK link]](https://grievance-frontend-theta.vercel.app/)

Project Description

A digital platform for citizens to register complaints about public services and for authorities to track, update, and resolve them efficiently.

The Problem Statement

Many cities lack a centralized grievance system. Citizens face delays and difficulty in tracking complaints, while authorities struggle to prioritize issues, monitor deadlines, and escalate unresolved complaints.

The Solution

A centralized platform where citizens can submit complaints with category and location, track status in real-time, and authorities can update statuses, add resolution notes, and automate SLA-based escalations.

Technical Details

Technologies/Components Used

Software:

Languages: Python, Dart

Frameworks: FastAPI (backend), Flutter (frontend)

Libraries: SQLAlchemy, APScheduler, http (Flutter)

Tools: VS Code, Git, Render, Netlify/Vercel

Hardware:

Not applicable

Features

Citizen complaint submission with category and location

Real-time status tracking for citizens

Automatic routing to department based on complaint type

Priority scoring and SLA-based automated escalation

Admin dashboard for viewing, updating, and resolving complaints

Cross-platform support via Flutter (mobile + web)

Resolution notes visible to citizens

Implementation

Backend Installation & Run:

# Install dependencies
pip install -r requirements.txt

# Run backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000


Frontend Installation & Run:

# Install Flutter packages
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build for Web
flutter build web


Notes: Update api_service.dart to point to the live backend URL:

static const String baseUrl = "https://grienvance-management.onrender.com";

Project Documentation

Screenshots:
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d7533cb7-8d8f-4423-8d4b-70b53ab2228c" />
it is the home page of the project citizen.Citizen can register and view complaints .THe third card ,admin mangment shows the works of admin ,which is manage the complaints ,admin should login to manage complaints
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3815d415-e67a-437a-afee-ce7236662a1b" />
this is the complaint registration page,citizen can select any one of the domains and add title and description
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/59d25604-7d40-4792-ac55-812700620ec7" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/60b9ecf6-589d-4c37-822c-e7df2eaf9e06" />
this is the complaint viewing page,the citizen can know the status of the complaint, therby more transparent
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/41f388f0-85e8-46fa-ad43-fc19f8411c20" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e4e18aff-b250-4cb2-aa41-318e34b1ae51" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/cb4395e5-1470-43e4-913a-ccb1c916b0fb" />
this is the admin login page and admin controls,admin should login into the platform, and can manage the complaints according to the 'handling' of the complaints;
progress of the complaint registerd can be managed by the admin

In short we have:
– Citizen complaint submission screen

– Admin dashboard showing complaints

– Complaint resolved with resolution note

Diagrams:

System Architecture: Backend handles API, database stores complaints, frontend communicates via REST API.

Application Workflow: Citizen submits → routed to department → status updated → SLA/priority enforced → resolved/escalated automatically.

API Documentation

Base URL: https://grienvance-management.onrender.com

Endpoints:

GET /complaints – Fetch all complaints

POST /complaints – Submit a new complaint

{
  "title": "Pothole on road",
  "description": "Large pothole near park",
  "category": "Road",
  "location": "Sector 5, City"
}


PUT /complaints/{id} – Update complaint status and resolution

{
  "status": "Resolved",
  "resolution": "Road repaired"
}

Team Contributions

Krishna P: Frontend development, Flutter integration, API testing

Navya J: Backend development, database setup, SLA automation
