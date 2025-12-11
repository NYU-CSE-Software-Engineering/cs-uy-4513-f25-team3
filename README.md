Here is a fully polished, Markdown-formatted, copy-ready **README.md** section.
I’ve improved spacing, headings, indentation, bullet formatting, and removed emojis so it looks professional on GitHub.

---

# CoRoute

## 📝 Description

The goal of this project is to design and develop a multi-module Software-as-a-Service (SaaS) system using Ruby on Rails.
CoRoute allows users to organize and list travel plans, select destinations, flights, and hotels, and make itineraries available for other users to join.

The platform functions as a social space where users can:

* Plan recreational trips together (publicly or privately)
* Communicate with each other
* Join itineraries
* Customize personal profiles

Organizers can:

* Create and modify itineraries
* Manage trip visibility
* Manage their own profiles

---

## 👥 Team Members & Roles

**Izzy Adams — Group Leader**

* Navbar
* View accounts
* Login
* Cucumber fixes for itinerary privacy

**Chris Jin**

* Join Itinerary
* Create Itinerary

**Muath Alghamdi**

* Sign Up
* Profile Edit
* Database Updates

**Jason Lin**

* Logout
* Itinerary Privacy
* Hotels and Flights

**Gabriel**

* View Group

**Jan Borowski**

* Group Chat
* Messages & Message Editing

---

## ⚙️ Setup Instructions

Follow these steps to run the application locally.

---

## 🔧 Requirements

This application uses the following frameworks, libraries, and development/testing tools.
Ensure your environment supports these dependencies before setup.

### **Core Framework**

* **Ruby:** `3.3.4`
* **Rails:** `~> 8.0.3`

### **Application Runtime**

* **SQLite3** — ActiveRecord database (`>= 2.1`)
* **Puma** — web server (`>= 5.0`)
* **Importmap-Rails** — JavaScript asset loading
* **Propshaft** — modern Rails asset pipeline
* **Turbo-Rails** — Hotwire navigation
* **Stimulus-Rails** — JS controllers
* **Jbuilder** — JSON templates
* **tzinfo-data** — timezone data for Windows/JRuby

### **Caching, Background Jobs & WebSockets**

* **solid_cache** — caching layer
* **solid_queue** — background job adapter
* **solid_cable** — Action Cable adapter

### **Boot Optimization & Deployment**

* **bootsnap** — reduces boot time
* **kamal** — Docker-based deployment
* **thruster** — Puma caching/compression

### **Development & Testing**

Installed only in `development` and/or `test` environments.

#### Debugging & Local Tools

* `debug`
* `web-console`

#### Testing Frameworks

* `rspec-rails`
* `capybara`
* `selenium-webdriver`
* `rails-controller-testing`
* `rack_session_access`
* `cucumber-rails`
* `database_cleaner-active_record`
* `simplecov`

#### Factories & Test Data

* `factory_bot_rails`
* `faker`

#### Static Analysis & Linting

* `brakeman`
* `rubocop-rails-omakase`

---

## 📥 Installation

* **Clone the repository:**

git clone https://github.com/NYU-CSE-Software-Engineering/cs-uy-4513-f25-team3

* **Install dependencies:**

bundle install

---

## 🗄️ Database Setup

* **Create the database:**

rails db:create

* **Run migrations:**

rails db:migrate

* **Seed the database:**

rails db:seed

---

## 🧪 Testing Instructions

Run the full automated test suite:

### Cucumber

cucumber

### RSpec

rspec