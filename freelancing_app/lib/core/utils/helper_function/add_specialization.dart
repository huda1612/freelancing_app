import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addSpectialization() async {
  List<Map<String, dynamic>> specializations = [
    //---------------------------------------------برمجة--------------------------------------------------------------------
    {
      "slug": "programming",
      "name": "البرمجة وتطوير المواقع والتطبيقات",
      "subSpecializations": [
        {
          "slug": "web_development",
          "name": "تطوير المواقع",
          "skills": [
            "html",
            "html5",
            "css",
            "css3",
            "sass",
            "scss",
            "bootstrap",
            "tailwind css",
            "responsive design",
            "javascript",
            "typescript",
            "dom manipulation",
            "ajax",
            "rest api",
            "react",
            "react hooks",
            "next js",
            "vue js",
            "nuxt js",
            "angular",
            "svelte",
            "node js",
            "express js",
            "nestjs",
            "php",
            "laravel",
            "symfony",
            "python",
            "django",
            "flask",
            "ruby on rails",
            "graphql",
            "websockets",
            "jwt authentication",
            "oauth",
            "webpack",
            "vite",
            "npm",
            "yarn"
          ]
        },
        {
          "slug": "mobile_development",
          "name": "تطوير تطبيقات الموبايل",
          "skills": [
            "flutter",
            "dart",
            "state management provider",
            "state management bloc",
            "getx",
            "android native",
            "kotlin",
            "java android",
            "ios native",
            "swift",
            "swiftui",
            "react native",
            "expo",
            "firebase auth",
            "firebase firestore",
            "firebase storage",
            "push notifications",
            "rest api integration",
            "graphql mobile",
            "ui ux mobile",
            "responsive mobile ui"
          ]
        },
        {
          "slug": "software_development",
          "name": "تطوير البرمجيات",
          "skills": [
            "c",
            "c++",
            "c sharp",
            "dotnet",
            "java",
            "spring boot",
            "python",
            "oop",
            "data structures",
            "algorithms",
            "desktop applications",
            "qt",
            "electron js",
            "api design",
            "microservices",
            "database design",
            "oop design patterns"
          ]
        },
        {
          "slug": "backend_databases",
          "name": "الخوادم وقواعد البيانات",
          "skills": [
            "sql",
            "mysql",
            "postgresql",
            "sqlite",
            "mongodb",
            "database design",
            "database normalization",
            "firebase",
            "firestore",
            "realtime database",
            "api development",
            "rest api",
            "graphql",
            "authentication",
            "authorization",
            "jwt",
            "server management",
            "linux",
            "docker",
            "kubernetes"
          ]
        },
        {
          "slug": "devops_cloud",
          "name": "DevOps والحوسبة السحابية",
          "skills": [
            "docker",
            "kubernetes",
            "ci cd",
            "github actions",
            "gitlab ci",
            "aws",
            "google cloud platform",
            "azure",
            "linux server",
            "nginx",
            "apache",
            "monitoring",
            "logging",
            "scaling"
          ]
        },
        {
          "slug": "core_programming",
          "name": "أساسيات البرمجة",
          "skills": [
            "problem solving",
            "data structures",
            "algorithms",
            "oop",
            "functional programming",
            "clean code",
            "solid principles",
            "design patterns",
            "git",
            "github",
            "version control"
          ]
        },
      ]
    },

    //------------------------------------------------------- ai ----------------------------------------------------------------------
    {
      "slug": "ai_machine_learning",
      "name": "ذكاء اصطناعي وتعلم الآلة",
      "subSpecializations": [
        {
          "slug": "machine learning",
          "name": "تعلم الآلة",
          "skills": [
            "machine learning",
            "supervised learning",
            "unsupervised learning",
            "reinforcement learning",
            "regression",
            "classification",
            "clustering",
            "decision trees",
            "random forest",
            "support vector machine",
            "k nearest neighbors",
            "feature engineering",
            "model evaluation",
            "overfitting",
            "underfitting",
            "scikit learn",
            "xgboost",
            "lightgbm"
          ]
        },
        {
          "slug": "deep_learning",
          "name": "التعلم العميق",
          "skills": [
            "neural networks",
            "deep learning",
            "convolutional neural networks",
            "recurrent neural networks",
            "long short term memory",
            "transformers",
            "backpropagation",
            "gradient descent",
            "tensorflow",
            "keras",
            "pytorch",
            "computer vision",
            "image classification",
            "object detection"
          ]
        },
        {
          "slug": "natural_language_processing",
          "name": "معالجة اللغة الطبيعية",
          "skills": [
            "natural language processing",
            "text processing",
            "tokenization",
            "stemming",
            "lemmatization",
            "sentiment analysis",
            "text classification",
            "named entity recognition",
            "word embeddings",
            "word2vec",
            "bert",
            "transformers nlp",
            "chatbots",
            "language models"
          ]
        },
        {
          "slug": "computer vision",
          "name": "رؤية الحاسوب",
          "skills": [
            "computer vision",
            "image processing",
            "opencv",
            "image segmentation",
            "edge detection",
            "object detection",
            "face recognition",
            "yolo",
            "cnn models"
          ]
        },
        {
          "slug": "data_science",
          "name": "علم البيانات",
          "skills": [
            "data analysis",
            "data cleaning",
            "data visualization",
            "pandas",
            "numpy",
            "matplotlib",
            "seaborn",
            "statistics",
            "probability",
            "exploratory data analysis",
            "feature selection"
          ]
        },
        {
          "id": "ai_deployment",
          "name": "نشر وتشغيل نماذج الذكاء الاصطناعي",
          "skills": [
            "model deployment",
            "machine learning operations",
            "docker",
            "kubernetes",
            "fastapi",
            "flask api",
            "rest api",
            "model serving",
            "cloud ai",
            "aws sagemaker",
            "google cloud ai"
          ]
        },
      ]
    },
    //------------------------------------------------------- هندسة عماره ----------------------------------------------------------------------
    {
      "slug": "architecture_engineering_design",
      "name": "هندسة، عمارة وتصميم داخلي",
      "subSpecializations": [
        {
          "slug": "architectural_design",
          "name": "التصميم المعماري",
          "skills": [
            "architectural design",
            "space planning",
            "building design",
            "urban planning",
            "concept design",
            "building codes",
            "construction standards",
            "site analysis",
            "sustainable architecture",
            "facade design",
            "structural concepts",
            "material selection"
          ]
        },
        {
          "slug": "interior_design",
          "name": "التصميم الداخلي",
          "skills": [
            "interior design",
            "space planning",
            "color theory",
            "lighting design",
            "furniture design",
            "material selection",
            "decor styling",
            "2d layout design",
            "3d visualization",
            "residential design",
            "commercial interior design"
          ]
        },
        {
          "slug": "civil_engineering",
          "name": "الهندسة المدنية",
          "skills": [
            "civil engineering",
            "structural analysis",
            "reinforced concrete design",
            "steel structures",
            "construction management",
            "surveying",
            "road design",
            "bridge design",
            "soil mechanics",
            "hydraulics",
            "project planning"
          ]
        },
        {
          "slug": "structural_engineering",
          "name": "الهندسة الإنشائية",
          "skills": [
            "structural engineering",
            "load analysis",
            "structural analysis",
            "reinforced concrete",
            "steel structures",
            "earthquake engineering",
            "structural design",
            "foundation design",
            "building stability"
          ]
        },
        {
          "slug": "cad_3d_modeling",
          "name": "الرسم الهندسي والنمذجة ثلاثية الأبعاد",
          "skills": [
            "autocad",
            "revit",
            "sketchup",
            "3ds max",
            "blender",
            "lumion",
            "vray",
            "rendering",
            "3d modeling",
            "technical drawing",
            "blueprint reading"
          ]
        },
        {
          "slug": "urban_planning",
          "name": "التخطيط العمراني",
          "skills": [
            "urban planning",
            "city planning",
            "land use planning",
            "transport planning",
            "infrastructure planning",
            "geographic information systems",
            "gis",
            "environmental planning"
          ]
        },
      ]
    },
    //------------------------------------------------------- تصميم فديو وصوت ----------------------------------------------------------------------
    {
      "slug": "design_media",
      "name": "تصميم، فيديو وصوتيات",
      "subSpecializations": [
        {
          "slug": "graphic_design",
          "name": "تصميم جرافيك",
          "skills": [
            "graphic design",
            "logo design",
            "branding",
            "visual identity",
            "poster design",
            "social media design",
            "banner design",
            "typography",
            "color theory",
            "layout design",
            "adobe photoshop",
            "adobe illustrator",
            "figma",
            "canva"
          ]
        },
        {
          "slug": "video_editing",
          "name": "مونتاج الفيديو",
          "skills": [
            "video editing",
            "cutting",
            "color grading",
            "video transitions",
            "motion graphics",
            "visual effects",
            "storytelling",
            "adobe premiere pro",
            "after effects",
            "davinci resolve",
            "youtube editing",
            "reels editing",
            "tiktok editing"
          ]
        },
        {
          "slug": "motion_graphics",
          "name": "موشن جرافيك",
          "skills": [
            "motion graphics",
            "animation",
            "2d animation",
            "explainer videos",
            "kinetic typography",
            "logo animation",
            "after effects",
            "blender basic animation"
          ]
        },
        {
          "slug": "audio_production",
          "name": "إنتاج صوتي",
          "skills": [
            "audio editing",
            "sound design",
            "voice over",
            "podcast editing",
            "noise reduction",
            "audio mixing",
            "audio mastering",
            "audacity",
            "adobe audition",
            "fl studio"
          ]
        },
        {
          "slug": "ui_ux_design",
          "name": "تصميم واجهات وتجربة المستخدم",
          "skills": [
            "ui design",
            "ux design",
            "user experience",
            "user interface",
            "wireframing",
            "prototyping",
            "user research",
            "figma",
            "adobe xd",
            "interaction design",
            "mobile ui design",
            "web ui design"
          ]
        },
        {
          "slug": "photography",
          "name": "التصوير الفوتوغرافي",
          "skills": [
            "photography",
            "portrait photography",
            "product photography",
            "event photography",
            "photo editing",
            "lightroom",
            "photoshop",
            "composition",
            "lighting",
            "retouching"
          ]
        }
      ]
    },
    //------------------------------------------------------- تسويق ----------------------------------------------------------------------
    {
      "slug": "digital_marketing_sales",
      "name": "تسويق إلكتروني ومبيعات",
      "subSpecializations": [
        {
          "slug": "social_media_marketing",
          "name": "التسويق عبر وسائل التواصل الاجتماعي",
          "skills": [
            "social media marketing",
            "content creation",
            "content strategy",
            "social media management",
            "instagram marketing",
            "facebook marketing",
            "tiktok marketing",
            "linkedin marketing",
            "engagement strategy",
            "community management",
            "influencer marketing",
            "paid ads",
            "social media ads"
          ]
        },
        {
          "slug": "seo",
          "name": "تحسين محركات البحث",
          "skills": [
            "seo",
            "on page seo",
            "off page seo",
            "technical seo",
            "keyword research",
            "backlinks",
            "search engine optimization",
            "google ranking",
            "google search console",
            "seo audit"
          ]
        },
        {
          "slug": "sem_ads",
          "name": "الإعلانات الممولة",
          "skills": [
            "google ads",
            "facebook ads",
            "instagram ads",
            "tiktok ads",
            "ppc",
            "cpc",
            "conversion optimization",
            "retargeting",
            "ad campaign management",
            "ads optimization"
          ]
        },
        {
          "slug": "email_marketing",
          "name": "التسويق عبر البريد الإلكتروني",
          "skills": [
            "email marketing",
            "email campaigns",
            "newsletter",
            "email automation",
            "mailchimp",
            "email copywriting",
            "lead nurturing",
            "crm marketing"
          ]
        },
        {
          "slug": "sales",
          "name": "المبيعات وإدارة العملاء",
          "skills": [
            "sales",
            "lead generation",
            "cold calling",
            "negotiation",
            "closing deals",
            "crm",
            "customer relationship management",
            "client acquisition",
            "sales funnel",
            "b2b sales",
            "b2c sales",
            "customer support"
          ]
        },
        {
          "slug": "copywriting",
          "name": "كتابة المحتوى الإعلاني",
          "skills": [
            "copywriting",
            "sales copy",
            "ad copy",
            "content writing",
            "storytelling",
            "persuasive writing",
            "landing page copy",
            "brand messaging",
            "script writing"
          ]
        }
      ]
    },
    //------------------------------------------------------- كتابة ----------------------------------------------------------------------
    {
      "slug": "writing_translation_languages",
      "name": "كتابة، تحرير، ترجمة ولغات",
      "subSpecializations": [
        {
          "slug": "content_writing",
          "name": "كتابة المحتوى",
          "skills": [
            "content writing",
            "article writing",
            "blog writing",
            "web content",
            "storytelling",
            "research writing",
            "creative writing",
            "technical writing",
            "script writing",
            "ghostwriting",
            "seo writing",
            "copywriting"
          ]
        },
        {
          "slug": "editing_proofreading",
          "name": "التحرير والتدقيق اللغوي",
          "skills": [
            "editing",
            "proofreading",
            "grammar correction",
            "punctuation correction",
            "text rewriting",
            "content editing",
            "fact checking",
            "readability improvement",
            "formatting"
          ]
        },
        {
          "slug": "translation",
          "name": "الترجمة",
          "skills": [
            "translation",
            "english arabic translation",
            "arabic english translation",
            "literary translation",
            "technical translation",
            "legal translation",
            "medical translation",
            "subtitling",
            "transcription",
            "localization"
          ]
        },
        {
          "slug": "languages_tutoring",
          "name": "تعليم اللغات",
          "skills": [
            "language teaching",
            "english tutoring",
            "arabic tutoring",
            "conversation practice",
            "grammar teaching",
            "writing coaching",
            "ielts preparation",
            "toefl preparation"
          ]
        }
      ]
    },
    //------------------------------------------------------- دعم ----------------------------------------------------------------------
    {
      "slug": "support_data_entry",
      "name": "دعم، مساعدة وإدخال بيانات",
      "subSpecializations": [
        {
          "slug": "virtual_assistant",
          "name": "مساعد افتراضي",
          "skills": [
            "virtual assistant",
            "email management",
            "calendar management",
            "appointment scheduling",
            "meeting coordination",
            "customer support",
            "live chat support",
            "administrative support",
            "task management",
            "online research",
            "data organization",
            "crm management",
            "social media management",
            "travel booking assistance",
            "document preparation",
            "report preparation",
            "file management",
            "project coordination",
            "data entry support"
          ]
        },
        {
          "slug": "data_entry",
          "name": "إدخال بيانات",
          "skills": [
            "data entry",
            "excel",
            "google sheets",
            "spreadsheet management",
            "data processing",
            "data collection",
            "data cleaning",
            "data validation",
            "copy typing",
            "fast typing",
            "document formatting",
            "pdf to excel",
            "pdf to word",
            "database entry",
            "product listing entry",
            "e commerce data entry",
            "online form filling",
            "data conversion",
            "data extraction"
          ]
        },
        {
          "slug": "customer_support",
          "name": "دعم العملاء",
          "skills": [
            "customer support",
            "technical support",
            "call center support",
            "live chat support",
            "email support",
            "help desk support",
            "ticket handling",
            "complaint handling",
            "customer service",
            "client communication",
            "crm systems",
            "zendesk support",
            "freshdesk support",
            "order tracking support",
            "refund handling",
            "issue resolution"
          ]
        },
        {
          "slug": "back_office",
          "name": "أعمال مكتبية خلفية",
          "skills": [
            "administrative work",
            "office management",
            "virtual office assistance",
            "document management",
            "report preparation",
            "file organization",
            "scheduling coordination",
            "email handling",
            "invoicing support",
            "basic bookkeeping support",
            "data reporting",
            "record keeping",
            "workflow coordination"
          ]
        }
      ]
    },
    //------------------------------------------------------- تدريب وتعليم ----------------------------------------------------------------------
    {
      "slug": "remote_training_education",
      "name": "تدريب وتعليم عن بعد",
      "subSpecializations": [
        {
          "slug": "online_teaching",
          "name": "تدريس عن بعد",
          "skills": [
            "online teaching",
            "virtual classroom management",
            "lesson planning",
            "course creation",
            "curriculum design",
            "student assessment",
            "interactive teaching",
            "zoom teaching",
            "google meet teaching",
            "educational content creation",
            "assignment creation",
            "exam preparation",
            "student engagement",
            "progress tracking"
          ]
        },
        {
          "slug": "tutoring",
          "name": "تدريب خصوصي",
          "skills": [
            "tutoring",
            "one on one teaching",
            "academic coaching",
            "exam preparation",
            "skill coaching",
            "homework help",
            "concept explanation",
            "interactive learning",
            "practice exercises",
            "study planning",
            "student mentoring",
            "language tutoring"
          ]
        },
        {
          "slug": "e_learning_content",
          "name": "إعداد محتوى تعليمي",
          "skills": [
            "e learning content creation",
            "educational video creation",
            "course design",
            "instructional design",
            "presentation design",
            "powerpoint design",
            "learning materials creation",
            "worksheet design",
            "quiz creation",
            "online course structuring",
            "educational script writing"
          ]
        },
        {
          "slug": "language_training",
          "name": "تدريب اللغات",
          "skills": [
            "language teaching",
            "english tutoring",
            "arabic tutoring",
            "conversation practice",
            "grammar teaching",
            "writing coaching",
            "listening practice",
            "speaking practice",
            "ielts preparation",
            "toefl preparation",
            "accent training"
          ]
        }
      ]
    },
    //------------------------------------------------------- استشارة ----------------------------------------------------------------------
    {
      "slug": "business_consulting_services",
      "name": "أعمال وخدمات استشارية",
      "subSpecializations": [
        {
          "slug": "business_consulting",
          "name": "استشارات الأعمال",
          "skills": [
            "business consulting",
            "business analysis",
            "strategic planning",
            "business development",
            "market analysis",
            "feasibility study",
            "process improvement",
            "risk analysis",
            "performance evaluation",
            "startup consulting",
            "growth strategy",
            "business model design"
          ]
        },
        {
          "slug": "financial_consulting",
          "name": "استشارات مالية",
          "skills": [
            "financial consulting",
            "budget planning",
            "financial analysis",
            "cost analysis",
            "investment planning",
            "cash flow analysis",
            "pricing strategy",
            "financial reporting",
            "profit analysis",
            "tax advisory basics"
          ]
        },
        {
          "slug": "marketing_consulting",
          "name": "استشارات تسويقية",
          "skills": [
            "marketing consulting",
            "digital marketing strategy",
            "brand strategy",
            "market research",
            "customer analysis",
            "sales strategy",
            "conversion optimization",
            "growth marketing",
            "campaign planning",
            "audience targeting"
          ]
        },
        {
          "slug": "hr_consulting",
          "name": "استشارات موارد بشرية",
          "skills": [
            "hr consulting",
            "recruitment strategy",
            "talent acquisition",
            "job description writing",
            "performance management",
            "employee evaluation",
            "workforce planning",
            "organizational structure",
            "interview planning",
            "team building strategy"
          ]
        },
        {
          "slug": "it_consulting",
          "name": "استشارات تقنية",
          "skills": [
            "it consulting",
            "software architecture",
            "system design",
            "technology consulting",
            "digital transformation",
            "cloud solutions",
            "cybersecurity basics",
            "database design",
            "api design",
            "tech stack selection"
          ]
        }
      ]
    }
  ];
  for (Map<String, dynamic> s in specializations) {
    await FirebaseFirestore.instance
        .collection('specializations')
        .doc(s['slug'])
        .set(s);
  }
}
