import 'it_terms_lesson.dart';

class ItTermsModule {
  final String moduleTitle;
  final List<ItTermsLesson> lessons;

  const ItTermsModule({
    required this.moduleTitle,
    required this.lessons,
  });

  static const List<ItTermsModule> programmingModules = [
    ItTermsModule(
      moduleTitle: "Programming & Development",
      lessons: [
        ItTermsLesson(
          title: "API (Application Programming Interface)",
          definition: "A set of rules or protocols that allows different software to communicate and integrate with each other (such as using the Gemini API).",
          notes: "• API acts as a bridge allowing different applications to communicate.\n• Commonly used in web services, mobile apps, and third-party integrations.",
        ),
        ItTermsLesson(
          title: "Database",
          definition: "An organized collection of data or information stored electronically (such as Firestore).",
          notes: "• Helps in efficient retrieval, management, and updating of data.\n• Can be relational (SQL) or non-relational (NoSQL like Firestore).",
        ),
        ItTermsLesson(
          title: "Framework",
          definition: "A pre-built structure or foundation used by developers to build applications faster and more easily (such as Flutter for mobile).",
          notes: "• Provides reusable code and standard guidelines.\n• Saves development time compared to building from scratch.",
        ),
        ItTermsLesson(
          title: "Repository (Repo)",
          definition: "A storage location where the source code of a project is stored and managed (such as GitHub).",
          notes: "• Essential for version control and collaboration among developers.\n• Tracks changes and history of the codebase.",
        ),
        ItTermsLesson(
          title: "Algorithm",
          definition: "A step-by-step set of rules or instructions followed by a computer to solve a problem or perform a task.",
          notes: "• Fundamental building block of programming and logic.\n• Determines the efficiency and speed of problem-solving.",
        ),
        ItTermsLesson(
          title: "Variable",
          definition: "A container or storage location used to hold data values that can change during the execution of a program.",
          notes: "• Has a specific data type (such as String, int, boolean).\n• Referenced by a unique name within the code.",
        ),
        ItTermsLesson(
          title: "Function / Method",
          definition: "A block of reusable code designed to perform a specific task whenever it is called.",
          notes: "• Helps keep code organized and prevents code repetition.\n• Can accept inputs (parameters) and return an output.",
        ),
        ItTermsLesson(
          title: "Object-Oriented Programming (OOP)",
          definition: "A programming paradigm based on the concept of 'objects', which contain data and methods.",
          notes: "• Key pillars include inheritance, encapsulation, polymorphism, and abstraction.\n• Widely used in languages like Java, C++, and Dart.",
        ),
        ItTermsLesson(
          title: "Debugging",
          definition: "The process of identifying, analyzing, and removing errors or 'bugs' from software code.",
          notes: "• Uses tools like breakpoints, print statements, and IDE debuggers.\n• Ensures the application runs smoothly without crashing.",
        ),
        ItTermsLesson(
          title: "IDE (Integrated Development Environment)",
          definition: "A software application that provides comprehensive facilities to computer programmers for software development.",
          notes: "• Combines code editor, compiler, debugger, and build automation (such as VS Code or Android Studio).\n• Boosts developer productivity.",
        ),
        ItTermsLesson(
          title: "Source Code",
          definition: "The collection of human-readable instructions written by a programmer in a programming language.",
          notes: "• Must be compiled or interpreted into machine code for the computer to execute.\n• Stored in repositories like GitHub.",
        ),
        ItTermsLesson(
          title: "Syntax",
          definition: "The set of rules that defines the combinations of symbols that are considered to be a correctly structured program.",
          notes: "• Every programming language has its own strict syntax rules.\n• Violating syntax results in compilation or build errors.",
        ),
        ItTermsLesson(
          title: "Compiler",
          definition: "A special program that translates human-readable source code into machine-readable binary code.",
          notes: "• Checks for syntax errors before running the application.\n• Generates an executable file for deployment.",
        ),
        ItTermsLesson(
          title: "Frontend",
          definition: "The visible part of an application or website that users interact with directly (such as UI built with Flutter).",
          notes: "• Focuses on user interface (UI) and user experience (UX).\n• Built using technologies like HTML, CSS, JavaScript, and Flutter widgets.",
        ),
        ItTermsLesson(
          title: "Backend",
          definition: "The server-side of an application that handles database management, user authentication, and server logic.",
          notes: "• Operates behind the scenes, hidden from the end-user.\n• Integrates services like Firebase, Node.js, and databases.",
        ),
      ],
    ),





    ItTermsModule(
      moduleTitle: "Networking & Internet",
      lessons: [
        ItTermsLesson(
          title: "IP Address (Internet Protocol Address)",
          definition: "A unique number or address assigned to every device connected to a network to identify it.",
          notes: "• Used for identifying devices on a local network or the internet.\n• Can be static (permanent) or dynamic (changes over time).",
        ),
        ItTermsLesson(
          title: "Cloud Computing",
          definition: "The storage and access of data and programs over the internet instead of your computer's own hard drive (such as Firebase or AWS).",
          notes: "• Offers scalability, remote access, and reduced local storage costs.\n• Includes services like Infrastructure as a Service (IaaS) and Platform as a Service (PaaS).",
        ),
        ItTermsLesson(
          title: "Bandwidth",
          definition: "The maximum amount of data transmitted over an internet connection in a given amount of time.",
          notes: "• Often measured in Mbps (Megabits per second).\n• Higher bandwidth allows faster data transfer and smoother streaming.",
        ),
        ItTermsLesson(
          title: "Firewall",
          definition: "A security system that acts as a barrier or protection between a secure internal network and the internet against threats.",
          notes: "• Can be hardware-based, software-based, or both.\n• Monitors incoming and outgoing network traffic based on security rules.",
        ),
        ItTermsLesson(
          title: "Router",
          definition: "A networking device that forwards data packets between computer networks, connecting local networks to the internet.",
          notes: "• Directs traffic across different networks.\n• Assigns local IP addresses to connected devices via DHCP.",
        ),
        ItTermsLesson(
          title: "DNS (Domain Name System)",
          definition: "The phonebook of the internet that translates human-friendly domain names (like google.com) into computer-friendly IP addresses.",
          notes: "• Eliminates the need to memorize numeric IP addresses.\n• Resolves requests through distributed root and authoritative servers.",
        ),
        ItTermsLesson(
          title: "LAN (Local Area Network)",
          definition: "A computer network that interconnects devices within a limited area such as a residence, school, or office building.",
          notes: "• Features high data-transfer rates and restricted geographic range.\n• Commonly uses Ethernet cables and Wi-Fi.",
        ),
        ItTermsLesson(
          title: "WAN (Wide Area Network)",
          definition: "A telecommunications network that extends over a large geographic distance, connecting multiple smaller networks like LANs.",
          notes: "• The internet itself is the largest and most well-known WAN.\n• Often connects offices in different cities or countries.",
        ),
        ItTermsLesson(
          title: "VPN (Virtual Private Network)",
          definition: "A service that creates a secure, encrypted connection over a less secure network, such as the public internet.",
          notes: "• Masks your IP address and protects online privacy.\n• Frequently used for remote work access and bypassing geo-restrictions.",
        ),
        ItTermsLesson(
          title: "HTTP / HTTPS (Hypertext Transfer Protocol Secure)",
          definition: "The underlying protocol used by the World Wide Web to define how messages are formatted and transmitted.",
          notes: "• HTTPS adds SSL/TLS encryption for secure data transmission.\n• Essential for protecting user credentials and sensitive information.",
        ),
        ItTermsLesson(
          title: "Packet",
          definition: "A small segment of a larger message or file transmitted across a digital network.",
          notes: "• Data is broken down into packets for efficient routing.\n• Reassembled into the original file upon reaching the destination.",
        ),
        ItTermsLesson(
          title: "MAC Address (Media Access Control Address)",
          definition: "A unique hardware identifier assigned to a network interface controller (NIC) for use as a network address.",
          notes: "• Hardcoded into hardware by the manufacturer.\n• Used for local physical network communication.",
        ),
        ItTermsLesson(
          title: "TCP/IP (Transmission Control Protocol / Internet Protocol)",
          definition: "The foundational suite of communication protocols used to interconnect network devices on the internet.",
          notes: "• TCP ensures reliable, ordered delivery of data packets.\n• IP handles the addressing and routing of packets.",
        ),
        ItTermsLesson(
          title: "Latency",
          definition: "The time delay experienced in a network system, measuring how long it takes for data to travel from source to destination.",
          notes: "• Measured in milliseconds (ms).\n• Lower latency is critical for real-time applications like online gaming and video calls.",
        ),
        ItTermsLesson(
          title: "Wi-Fi",
          definition: "A technology that uses radio waves to provide wireless high-speed internet and network connections.",
          notes: "• Operates primarily on 2.4 GHz, 5 GHz, and 6 GHz frequency bands.\n• Eliminates the need for physical wired cables in a LAN.",
        ),
      ],
    ),






    ItTermsModule(
      moduleTitle: "Hardware & Architecture",
      lessons: [
        ItTermsLesson(
          title: "CPU (Central Processing Unit)",
          definition: "The 'brain' of the computer that processes instructions and calculations.",
          notes: "• Responsible for executing commands from hardware and software.\n• Measured in clock speed (GHz) and core counts.",
        ),
        ItTermsLesson(
          title: "RAM (Random Access Memory)",
          definition: "The computer's temporary data storage used by actively running programs.",
          notes: "• Volatile memory (data is lost when the computer turns off).\n• Allows fast read and write access for multitasking.",
        ),
        ItTermsLesson(
          title: "SSD (Solid State Drive)",
          definition: "A type of storage device that is much faster than a traditional HDD (Hard Disk Drive).",
          notes: "• Uses flash memory with no moving parts.\n• Results in faster boot times and quicker file transfers.",
        ),
        ItTermsLesson(
          title: "GPU (Graphics Processing Unit)",
          definition: "A specialized electronic circuit designed to rapidly manipulate and alter memory to accelerate the creation of images.",
          notes: "• Essential for gaming, video editing, and rendering 3D graphics.\n• Increasingly used for training machine learning and AI models.",
        ),
        ItTermsLesson(
          title: "Motherboard",
          definition: "The main printed circuit board in a computer that houses the CPU, memory, connectors for input/output devices, and expansion slots.",
          notes: "• Acts as the central backbone connecting all hardware components together.\n• Provides power distribution and communication pathways.",
        ),
        ItTermsLesson(
          title: "HDD (Hard Disk Drive)",
          definition: "A traditional non-volatile storage device that uses mechanical platters and a moving magnetic read/write head to access data.",
          notes: "• Slower than SSDs due to moving mechanical parts.\n• Offers high storage capacities at a lower cost per gigabyte.",
        ),
        ItTermsLesson(
          title: "Power Supply Unit (PSU)",
          definition: "A hardware component that converts mains AC power from a wall outlet into low-voltage DC power for the internal components of a computer.",
          notes: "• Ensures stable power delivery to the motherboard, CPU, and GPU.\n• Rated by wattage and efficiency certificates (such as 80 Plus).",
        ),
        ItTermsLesson(
          title: "ROM (Read-Only Memory)",
          definition: "A type of non-volatile memory used in computers and other electronic devices where data is permanently stored.",
          notes: "• Retains data even when the computer is turned off.\n• Typically stores firmware like the BIOS/UEFI needed during startup.",
        ),
        ItTermsLesson(
          title: "Cache Memory",
          definition: "A small, extremely fast type of volatile computer memory that provides high-speed data access to the CPU.",
          notes: "• Located close to or directly on the CPU die (L1, L2, L3 caches).\n• Stores frequently used instructions and data to minimize access time.",
        ),
        ItTermsLesson(
          title: "BIOS / UEFI",
          definition: "Firmware interface used to perform hardware initialization during the booting process and provide runtime services for operating systems.",
          notes: "• Stored on a motherboard chip and runs as soon as the computer is powered on.\n• UEFI is the modern, more secure successor to traditional BIOS.",
        ),
        ItTermsLesson(
          title: "Bus",
          definition: "A communication system that transfers data between components inside a computer, or between computers.",
          notes: "• Includes data buses, address buses, and control buses.\n• Determines how fast data can move between the CPU, RAM, and peripherals.",
        ),
        ItTermsLesson(
          title: "Peripherals",
          definition: "An auxiliary hardware device used to put information into and get information out of the computer.",
          notes: "• Divided into input devices (keyboard, mouse) and output devices (monitor, printer).\n• Connects via USB, Bluetooth, or dedicated ports.",
        ),
        ItTermsLesson(
          title: "Heat Sink / Cooling Fan",
          definition: "A passive or active heat exchanger that cools a device by dissipating heat into the surrounding air.",
          notes: "• Prevents CPUs and GPUs from overheating during heavy workloads.\n• Can be air-cooled with fans or liquid-cooled with pump blocks and radiators.",
        ),
        ItTermsLesson(
          title: "Expansion Card",
          definition: "A printed circuit board that can be inserted into an expansion slot (like PCIe) on a computer's motherboard.",
          notes: "• Used to add functionality such as dedicated graphics, sound cards, or extra network ports.\n• Allows modular upgrading of desktop computer systems.",
        ),
        ItTermsLesson(
          title: "Form Factor",
          definition: "The physical size, shape, and configuration of computer hardware components or cases.",
          notes: "• Standardizes motherboard sizes (e.g., ATX, Micro-ATX, Mini-ITX).\n• Ensures proper compatibility between cases, power supplies, and internal parts.",
        ),
      ],
    ),





    ItTermsModule(
      moduleTitle: "Web Development & UI/UX",
      lessons: [
        ItTermsLesson(
          title: "Front-end",
          definition: "The part of a website or app that users see and interact with (where you use Flutter).",
          notes: "• Built using technologies like HTML, CSS, JavaScript, and Flutter.\n• Focuses on visual presentation and user interaction.",
        ),
        ItTermsLesson(
          title: "Back-end",
          definition: "The 'behind-the-scenes' part of the system where database management, server operations, and logic take place (such as Firebase).",
          notes: "• Handles data processing, authentication, and server communication.\n• Users do not directly see or interact with this layer.",
        ),
        ItTermsLesson(
          title: "Responsive Design",
          definition: "A design approach that adjusts and looks great on any screen size (mobile, tablet, desktop).",
          notes: "• Ensures optimal viewing experience across various devices.\n• Uses flexible grids, layouts, and media queries.",
        ),
        ItTermsLesson(
          title: "UI/UX (User Interface / User Experience)",
          definition: "Refers to the look and design of an app (UI) as well as how easy and enjoyable it is for the user to use (UX).",
          notes: "• UI focuses on visual elements like buttons, colors, and typography.\n• UX focuses on overall user satisfaction, flow, and usability.",
        ),
        ItTermsLesson(
          title: "HTML (HyperText Markup Language)",
          definition: "The standard markup language used to create and structure documents for display on the World Wide Web.",
          notes: "• Defines elements like headings, paragraphs, links, and images.\n• Acts as the fundamental skeleton of web pages.",
        ),
        ItTermsLesson(
          title: "CSS (Cascading Style Sheets)",
          definition: "A stylesheet language used to describe the presentation and styling of a document written in HTML.",
          notes: "• Controls colors, fonts, layouts, animations, and responsiveness.\n• Separates content structure from visual design.",
        ),
        ItTermsLesson(
          title: "JavaScript",
          definition: "A dynamic programming language that enables interactive web pages and is an essential part of web applications.",
          notes: "• Runs on the client-side to handle dynamic content, pop-ups, and game logic.\n• Can also run on the server-side using platforms like Node.js.",
        ),
        ItTermsLesson(
          title: "DOM (Document Object Model)",
          definition: "A programming interface that allows scripts to inspect and update the content, structure, and style of a web document.",
          notes: "• Represents the page so programs can change document structure and style.\n• Connects web pages to scripting languages like JavaScript.",
        ),
        ItTermsLesson(
          title: "REST API (Representational State Transfer API)",
          definition: "An architectural style for providing standards between computer systems on the web, making it easier for systems to communicate.",
          notes: "• Uses standard HTTP methods like GET, POST, PUT, and DELETE.\n• Commonly transfers data in JSON or XML formats.",
        ),
        ItTermsLesson(
          title: "Wireframe",
          definition: "A visual guide that represents the skeletal framework of a website or application during the design phase.",
          notes: "• Focuses on layout, content placement, and user flow rather than graphics.\n• Created before high-fidelity mockups and coding.",
        ),
        ItTermsLesson(
          title: "Prototype",
          definition: "An interactive, high-fidelity simulation of an application or website used for testing user flows and designs.",
          notes: "• Allows stakeholders and users to click through screens before development begins.\n• Helps identify usability flaws early in the design process.",
        ),
        ItTermsLesson(
          title: "State Management",
          definition: "The practice of managing the state (data that changes over time) of user interface controls and application data.",
          notes: "• Crucial in frameworks like Flutter to keep the UI synchronized with data.\n• Includes approaches like Provider, Riverpod, BLoC, and setState.",
        ),
        ItTermsLesson(
          title: "Single Page Application (SPA)",
          definition: "A web application or website that interacts with the user by dynamically rewriting the current web page with new data from the web server.",
          notes: "• Prevents entire pages from reloading, offering a smoother user experience.\n• Built using modern frameworks like React, Vue, or Flutter Web.",
        ),
        ItTermsLesson(
          title: "Cross-Platform Development",
          definition: "The practice of developing software applications that are compatible with multiple mobile operating systems using a single codebase.",
          notes: "• Frameworks like Flutter and React Native make this possible.\n• Saves time and reduces development costs compared to native coding.",
        ),
        ItTermsLesson(
          title: "Accessibility (a11y)",
          definition: "The design of products, devices, services, or environments for people with disabilities.",
          notes: "• Ensures screen readers, high contrast modes, and touch targets work for everyone.\n• An essential pillar of inclusive UX design.",
        ),
      ],
    ),





    ItTermsModule(
      moduleTitle: "Data Science & Artificial Intelligence",
      lessons: [
        ItTermsLesson(
          title: "Machine Learning (ML)",
          definition: "A branch of AI where systems learn from data without being explicitly programmed.",
          notes: "• Improves automatically through experience and training data.\n• Used in recommendation systems, image recognition, and predictive analytics.",
        ),
        ItTermsLesson(
          title: "Big Data",
          definition: "Extremely large and complex datasets that traditional databases cannot process.",
          notes: "• Characterized by volume, velocity, and variety.\n• Requires specialized tools and distributed computing frameworks to analyze.",
        ),
        ItTermsLesson(
          title: "Algorithm",
          definition: "A step-by-step set of rules or instructions followed by a computer to solve a problem or perform a task.",
          notes: "• Fundamental building block of programming and data processing.\n• Can range from simple sorting to complex AI decision-making.",
        ),
        ItTermsLesson(
          title: "Artificial Intelligence (AI)",
          definition: "The simulation of human intelligence processes by machines, especially computer systems.",
          notes: "• Includes learning, reasoning, problem-solving, perception, and language understanding.\n• Powers modern applications like virtual assistants and automated agents.",
        ),
        ItTermsLesson(
          title: "Deep Learning",
          definition: "A subset of machine learning based on artificial neural networks with multiple layers (hence 'deep').",
          notes: "• Mimics the human brain's interconnected neuron structure.\n• Drives advanced technologies like computer vision, speech recognition, and large language models (like Gemini).",
        ),
        ItTermsLesson(
          title: "Neural Network",
          definition: "A computing system inspired by the biological neural networks that constitute animal brains.",
          notes: "• Consists of an input layer, hidden layers, and an output layer.\n• Learns to recognize patterns through continuous training and backpropagation.",
        ),
        ItTermsLesson(
          title: "Data Mining",
          definition: "The process of discovering patterns, anomalies, and useful information from large datasets using machine learning, statistics, and database systems.",
          notes: "• Used in market research, customer segmentation, and fraud detection.\n• Turns raw data into actionable business intelligence.",
        ),
        ItTermsLesson(
          title: "Natural Language Processing (NLP)",
          definition: "A branch of AI that gives computers the ability to understand, interpret, and manipulate human language.",
          notes: "• Powers chatbots, translation tools, sentiment analysis, and speech-to-text.\n• Bridges the gap between human communication and computer comprehension.",
        ),
        ItTermsLesson(
          title: "Computer Vision",
          definition: "A field of artificial intelligence that enables computers to derive meaningful information from digital images, videos, and other visual inputs.",
          notes: "• Used in facial recognition, medical imaging, and autonomous vehicles.\n• Involves image classification, object detection, and segmentation.",
        ),
        ItTermsLesson(
          title: "Dataset",
          definition: "A structured collection of data typically organized in tabular form, rows, columns, or files used for analysis and model training.",
          notes: "• Split into training, validation, and testing sets during machine learning development.\n• Quality and quantity directly affect AI model accuracy.",
        ),
        ItTermsLesson(
          title: "Predictive Analytics",
          definition: "The use of data, statistical algorithms, and machine learning techniques to identify the likelihood of future outcomes based on historical data.",
          notes: "• Extensively used in finance, healthcare, and retail forecasting.\n• Helps organizations make proactive data-driven decisions.",
        ),
        ItTermsLesson(
          title: "Data Cleaning / Wrangling",
          definition: "The process of detecting and correcting corrupt, inaccurate, or duplicate records from a record set or database.",
          notes: "• Essential step before feeding data into machine learning models.\n• Ensures high data quality and prevents inaccurate results ('garbage in, garbage out').",
        ),
        ItTermsLesson(
          title: "Supervised Learning",
          definition: "A type of machine learning where an algorithm is trained using labeled data to map inputs to desired outputs.",
          notes: "• Common tasks include classification (e.g., spam detection) and regression (e.g., price prediction).\n• Requires human-labeled datasets for training.",
        ),
        ItTermsLesson(
          title: "Unsupervised Learning",
          definition: "A type of machine learning that looks for previously undetected patterns in a dataset with zero pre-existing labels.",
          notes: "• Primary techniques include clustering (grouping similar data) and association.\n• Used for customer segmentation and anomaly detection.",
        ),
        ItTermsLesson(
          title: "Overfitting",
          definition: "A modeling error in machine learning where a function is too closely aligned to a particular set of data, and may therefore fail to fit additional data.",
          notes: "• Happens when a model learns the training data too well, including noise and random fluctuations.\n• Mitigated by using regularization, dropout layers, and diverse test datasets.",
        ),
      ],
    ),






    ItTermsModule(
      moduleTitle: "Operating Systems & Software Engineering",
      lessons: [
        ItTermsLesson(
          title: "Open Source",
          definition: "Software whose source code is freely available, modifiable, and shareable by anyone.",
          notes: "• Promotes community collaboration and transparency.\n• Examples include Linux, Python, and various developer tools.",
        ),
        ItTermsLesson(
          title: "Debugging",
          definition: "The process of finding and fixing errors or 'bugs' in code.",
          notes: "• Essential skill for software developers using tools like IDE breakpoints and logs.\n• Helps ensure application stability and correct behavior.",
        ),
        ItTermsLesson(
          title: "Version Control",
          definition: "A system (such as Git) that records changes to code so it can easily be rolled back or collaborated on by other developers.",
          notes: "• Tracks history and manages code branches.\n• Platforms like GitHub use version control for teamwork.",
        ),
        ItTermsLesson(
          title: "Operating System (OS)",
          definition: "System software that manages computer hardware, software resources, and provides common services for computer programs.",
          notes: "• Acts as an intermediary between users/applications and computer hardware.\n• Examples include Windows, macOS, Linux, Android, and iOS.",
        ),
        ItTermsLesson(
          title: "Kernel",
          definition: "The core component of an operating system that acts as the primary interface between the computer's hardware and its processes.",
          notes: "• Manages memory, CPU scheduling, input/output operations, and peripheral devices.\n• Controls low-level system security and resource allocation.",
        ),
        ItTermsLesson(
          title: "Process",
          definition: "An instance of a computer program that is being executed by one or more threads.",
          notes: "• Contains the program code and its current activity managed by the OS.\n• Allocated with dedicated system memory and CPU time.",
        ),
        ItTermsLesson(
          title: "Thread",
          definition: "The smallest unit of execution within a process that can be scheduled and executed by an operating system's CPU.",
          notes: "• Enables multithreading for concurrent execution and better performance.\n• Shares memory space with other threads in the same process.",
        ),
        ItTermsLesson(
          title: "Virtual Machine (VM)",
          definition: "A digital emulation of a computer system that runs on top of physical hardware via a hypervisor.",
          notes: "• Allows running multiple operating systems on a single physical machine.\n• Commonly used in cloud computing, server virtualization, and software testing.",
        ),
        ItTermsLesson(
          title: "Software Development Life Cycle (SDLC)",
          definition: "A structured process used by software teams to design, develop, and test high-quality software applications.",
          notes: "• Includes phases like requirements analysis, design, coding, testing, deployment, and maintenance.\n• Guides projects from conception to final release.",
        ),
        ItTermsLesson(
          title: "Agile Methodology",
          definition: "An iterative approach to project management and software development that helps teams deliver value to their customers faster.",
          notes: "• Focuses on continuous improvement, flexibility, and cross-functional teamwork.\n• Breaks development into short cycles called sprints.",
        ),
        ItTermsLesson(
          title: "Code Refactoring",
          definition: "The process of restructuring existing computer code without changing its external behavior to improve non-functional attributes.",
          notes: "• Cleans up messy code, reduces technical debt, and improves readability.\n• Makes the codebase easier to maintain and extend in the future.",
        ),
        ItTermsLesson(
          title: "Software Testing",
          definition: "The process of evaluating a software application to find bugs, ensure quality, and verify that it meets specified requirements.",
          notes: "• Includes unit tests, integration tests, system tests, and user acceptance testing (UAT).\n• Prevents defects from reaching end-users.",
        ),
        ItTermsLesson(
          title: "Shell / Terminal",
          definition: "A command-line interface used to interact with an operating system using text-based commands.",
          notes: "• Allows developers to execute scripts, manage files, and control system processes directly.\n• Examples include Bash, Zsh, and PowerShell.",
        ),
        ItTermsLesson(
          title: "Device Driver",
          definition: "A specialized computer program that operates or controls a particular type of device attached to a computer.",
          notes: "• Translates operating system commands into hardware-specific instructions.\n• Essential for hardware like graphics cards, printers, and mice to function properly.",
        ),
        ItTermsLesson(
          title: "Containerization",
          definition: "A lightweight form of virtualization that packages an application and its dependencies together so it can run reliably across different computing environments.",
          notes: "• Tools like Docker ensure consistency from development to production.\n• Isolates apps from the host system while sharing the underlying OS kernel.",
        ),
      ],
    ),





    ItTermsModule(
      moduleTitle: "Emerging Technologies",
      lessons: [
        ItTermsLesson(
          title: "IoT (Internet of Things)",
          definition: "Connecting everyday objects (such as Arduino, smart appliances, sensors) to the internet to send and receive data.",
          notes: "• Enables smart homes, automation, and remote monitoring.\n• Bridges physical hardware with digital networks.",
        ),
        ItTermsLesson(
          title: "Blockchain",
          definition: "A decentralized digital ledger that securely records transactions in a way that cannot be altered.",
          notes: "• Known for powering cryptocurrencies like Bitcoin.\n• Provides high security through cryptographic hashing and decentralization.",
        ),
        ItTermsLesson(
          title: "Virtual Reality / Augmented Reality (VR / AR)",
          definition: "Technologies that create a simulated digital environment (VR) or add digital elements to the real world (AR).",
          notes: "• VR completely immerses the user in a digital world using headsets.\n• AR overlays digital graphics onto the physical environment (e.g., smartphone cameras).",
        ),
        ItTermsLesson(
          title: "Edge Computing",
          definition: "A distributed computing paradigm that brings computation and data storage closer to the sources of data to improve response times and save bandwidth.",
          notes: "• Processes data locally on devices rather than relying solely on a centralized cloud.\n• Crucial for real-time IoT devices and autonomous systems.",
        ),
        ItTermsLesson(
          title: "Quantum Computing",
          definition: "A rapidly-emerging technology that harnesses the laws of quantum mechanics to solve problems too complex for classical computers.",
          notes: "• Uses qubits instead of traditional binary bits (0s and 1s).\n• Capable of performing exponential calculations simultaneously.",
        ),
        ItTermsLesson(
          title: "5G Technology",
          definition: "The fifth-generation cellular network technology delivering higher multi-Gbps peak data speeds, ultra-low latency, and more reliability.",
          notes: "• Enables instantaneous communication for mobile and IoT devices.\n• Powers smart cities, massive device connectivity, and advanced mobile streaming.",
        ),
        ItTermsLesson(
          title: "Artificial General Intelligence (AGI)",
          definition: "A hypothetical AI that matches or exceeds human intelligence across a broad range of cognitive tasks.",
          notes: "• Unlike narrow AI (which handles specific tasks), AGI can learn and adapt to any intellectual challenge.\n• Represents a major focal point in future AI research.",
        ),
        ItTermsLesson(
          title: "Metaverse",
          definition: "A network of 3D virtual worlds focused on social connection, blending virtual reality, augmented reality, and the internet.",
          notes: "• Allows users to interact, work, and play in persistent virtual spaces using avatars.\n• Supported by emerging web3 and immersive hardware technologies.",
        ),
        ItTermsLesson(
          title: "Autonomous Vehicles",
          definition: "Self-driving cars and transport systems that use sensors, cameras, radar, and AI to travel between destinations without a human operator.",
          notes: "• Relies heavily on computer vision and real-time machine learning inference.\n• Aims to reduce traffic accidents and transform modern transit.",
        ),
        ItTermsLesson(
          title: "Biometric Authentication",
          definition: "A security process that relies on the unique biological characteristics of an individual to verify their identity.",
          notes: "• Includes fingerprint scanners, facial recognition, and iris scans.\n• Provides higher security and convenience compared to traditional passwords.",
        ),
        ItTermsLesson(
          title: "Robotic Process Automation (RPA)",
          definition: "A software technology that makes it easy to build, deploy, and manage software robots that emulate human actions interacting with digital systems.",
          notes: "• Automates repetitive, rule-based digital tasks.\n• Increases operational efficiency and reduces human error in business workflows.",
        ),
        ItTermsLesson(
          title: "3D Printing (Additive Manufacturing)",
          definition: "A process of making three-dimensional solid objects from a digital file by laying down successive layers of material.",
          notes: "• Used in prototyping, manufacturing, aerospace, and medical prosthetics.\n• Allows custom and complex geometries that traditional manufacturing cannot easily achieve.",
        ),
        ItTermsLesson(
          title: "Cybersecurity Mesh",
          definition: "A modern security approach that provides a distributed architectural safeguard to secure all types of assets, regardless of location.",
          notes: "• Replaces traditional perimeter-based security models.\n• Essential for protecting decentralized remote workforces and cloud environments.",
        ),
        ItTermsLesson(
          title: "Generative AI",
          definition: "Artificial intelligence models that can generate new content, including text, images, code, and audio, based on the prompts they receive.",
          notes: "• Powered by large language models and neural networks (like Gemini and GPT).\n• Revolutionizing content creation, software development, and design workflows.",
        ),
        ItTermsLesson(
          title: "Digital Twin",
          definition: "A virtual representation that serves as the real-time digital counterpart of a physical object, process, or system.",
          notes: "• Used to simulate, analyze, and predict the performance of physical assets (such as jet engines or factory floors).\n• Combines IoT sensor data with AI and machine learning modeling.",
        ),
      ],
    ),

  ];
}