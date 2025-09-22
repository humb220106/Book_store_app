import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../config/firebase_options.dart';
import '../../models/book.dart';

/// List of 40 books
final List<Book> seedBooksList = [
  Book(
    id: "book_001",
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    description:
        "Bilbo Baggins embarks on a grand adventure with a band of dwarves to reclaim a lost kingdom from a dragon.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=400&h=600&fit=crop",
    genre: "Fantasy",
    price: 14.99,
    rating: 4.8,
    reviewCount: 21542,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
  Book(
    id: "book_002",
    title: "1984",
    author: "George Orwell",
    description:
        "A dystopian novel about surveillance, totalitarianism, and the dangers of absolute power.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544717302-9cdcb1f5942b?w=400&h=600&fit=crop",
    genre: "Dystopian",
    price: 12.49,
    rating: 4.7,
    reviewCount: 53211,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
  Book(
    id: "book_003",
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    description:
        "A young girl in the Depression-era South learns about justice and empathy through her father’s defense of a Black man wrongly accused of a crime.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=400&h=600&fit=crop",
    genre: "Classic",
    price: 15.99,
    rating: 4.9,
    reviewCount: 65432,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
  Book(
    id: "book_004",
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description:
        "A tragic story of wealth, love, and the American Dream set in the Jazz Age.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    genre: "Classic",
    price: 13.49,
    rating: 4.3,
    reviewCount: 28764,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
  Book(
    id: "book_005",
    title: "The Midnight Library",
    author: "Matt Haig",
    description:
        "Between life and death lies the Midnight Library, where Nora Seed gets to explore infinite versions of her life. Each book represents a different path she could have taken, from rock star to glaciologist. A philosophical exploration of regret, possibility, and what makes life worth living. Haig weaves together humor, wisdom, and hope in this extraordinary tale. Discover what happens when you get the chance to live all your unlived lives.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Philosophical Fiction",
    price: 16.49,
    rating: 4.5,
    reviewCount: 14367,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_006",
    title: "The Invisible Life of Addie LaRue",
    author: "V.E. Schwab",
    description:
        "In 1714, Addie LaRue makes a desperate bargain to live forever and is cursed to be forgotten by everyone she meets. Three hundred years later, she meets Henry, the first person to remember her name. This epic tale spans centuries, exploring themes of memory, identity, and what it means to be truly seen. Schwab crafts a hauntingly beautiful story about the power of being remembered. Experience a love story unlike any other, where remembering becomes the greatest gift of all.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-e4f6d10f5e5f?w=400&h=600&fit=crop",
    genre: "Fantasy Romance",
    price: 18.99,
    rating: 4.4,
    reviewCount: 9876,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_007",
    title: "Educated",
    author: "Tara Westover",
    description:
        "Born to survivalists in the mountains of Idaho, Tara Westover never went to school or received medical care as a child. Her quest for knowledge transformed her, taking her from scavenging in her father's junkyard to Harvard and Cambridge. This powerful memoir explores the struggle between loyalty to family and the pursuit of individual growth. Westover's journey is both heartbreaking and inspiring as she discovers the transformative power of education. A testament to the human capacity for change and the importance of thinking for yourself.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "Biography/Memoir",
    price: 16.99,
    rating: 4.8,
    reviewCount: 25643,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_008",
    title: "The Thursday Murder Club",
    author: "Richard Osman",
    description:
        "Four unlikely friends meet weekly in a retirement village to investigate cold cases, but they suddenly find themselves in the middle of their first live case. Elizabeth, Joyce, Ibrahim, and Ron use their years of experience and wisdom to solve mysteries that have baffled the police. A charming blend of humor, heart, and clever plotting that proves age is just a number. These septuagenarian sleuths will win your heart with their wit and determination. Perfect for fans of cozy mysteries with unforgettable characters.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Cozy Mystery",
    price: 15.49,
    rating: 4.6,
    reviewCount: 12890,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_009",
    title: "Dune",
    author: "Frank Herbert",
    description:
        "Set in the distant future on the desert planet Arrakis, young Paul Atreides becomes embroiled in a struggle for control of the universe's most valuable resource. This epic space opera combines politics, religion, ecology, and technology in a richly detailed universe. Herbert created one of the most complex and influential science fiction novels ever written. The story explores themes of power, destiny, and the relationship between humanity and nature. Experience the book that inspired countless science fiction works and blockbuster films.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=600&fit=crop",
    genre: "Science Fiction",
    price: 19.99,
    rating: 4.7,
    reviewCount: 34521,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_010",
    title: "The Song of Achilles",
    author: "Madeline Miller",
    description:
        "A breathtaking retelling of the Iliad, told through the eyes of Patroclus, Achilles' closest companion. Miller brings ancient Greece to vivid life in this tale of love, honor, and tragic destiny. The novel explores the deep bond between two warriors against the backdrop of the Trojan War. Beautiful prose and emotional depth make this a modern classic that reimagines one of literature's greatest stories. Prepare for a story that will break your heart and stay with you long after the final page.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    genre: "Historical Fiction",
    price: 17.49,
    rating: 4.9,
    reviewCount: 28947,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_011",
    title: "Circe",
    author: "Madeline Miller",
    description:
        "The story of Circe, the Greek goddess who transforms Odysseus's men into pigs, told from her own perspective. Born strange and scorned by her divine family, Circe discovers her power lies in witchcraft and mortal magic. Miller's lyrical prose brings the ancient world to stunning life in this feminist retelling. The novel explores themes of power, transformation, and finding your own strength. A captivating blend of mythology, magic, and deeply human emotions that will enchant readers.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Mythology/Fantasy",
    price: 17.99,
    rating: 4.8,
    reviewCount: 21765,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_012",
    title: "The Martian",
    author: "Andy Weir",
    description:
        "When astronaut Mark Watney is presumed dead and left behind on Mars, he must use his ingenuity and scientific knowledge to survive. With limited supplies and no way to communicate with Earth, Watney faces impossible odds. This gripping survival story combines hard science with humor and human resilience. Weir's attention to scientific detail makes every challenge feel authentic and solvable. A thrilling adventure that proves the power of human determination and problem-solving.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=600&fit=crop",
    genre: "Science Fiction",
    price: 15.99,
    rating: 4.7,
    reviewCount: 19834,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_013",
    title: "The Handmaid's Tale",
    author: "Margaret Atwood",
    description:
        "In the Republic of Gilead, women are valued only for their ability to bear children in this dystopian masterpiece. Offred navigates a world where reading is forbidden and her every move is monitored. Atwood's chilling vision of a totalitarian future feels eerily relevant to modern times. The novel explores themes of freedom, identity, and resistance against oppression. A powerful and haunting story that serves as both entertainment and warning about the fragility of human rights.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-e4f6d10f5e5f?w=400&h=600&fit=crop",
    genre: "Dystopian Fiction",
    price: 16.49,
    rating: 4.6,
    reviewCount: 27583,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_014",
    title: "Klara and the Sun",
    author: "Kazuo Ishiguro",
    description:
        "Told from the perspective of Klara, an artificial friend with remarkable observational powers, who watches the world from a store window. When she's chosen as a companion for sick teenager Josie, Klara embarks on a journey to understand human love and devotion. Ishiguro masterfully explores what it means to love and be human through the eyes of an artificial being. The novel raises profound questions about consciousness, sacrifice, and the nature of the soul. A deeply moving meditation on love, hope, and what makes us human.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Literary Fiction",
    price: 18.49,
    rating: 4.3,
    reviewCount: 8967,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_015",
    title: "The Seven Moons of Maali Almeida",
    author: "Shehan Karunatilaka",
    description:
        "Photographer Maali Almeida wakes up dead in what seems like a celestial visa office, with seven moons to solve his own murder. Set against the backdrop of Sri Lanka's civil war, this darkly comic supernatural thriller follows Maali's ghostly investigation. Karunatilaka blends magical realism with sharp political commentary and biting humor. The novel explores themes of war, corruption, and the afterlife with both gravity and wit. A unique and powerful story that won the 2022 Booker Prize for its innovative narrative and social consciousness.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Magical Realism",
    price: 19.49,
    rating: 4.4,
    reviewCount: 6743,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_016",
    title: "Project Hail Mary",
    author: "Andy Weir",
    description:
        "Ryland Grace wakes up on a spaceship with no memory of how he got there, tasked with saving humanity from extinction. As his memories slowly return, he realizes he's on a desperate mission to save Earth from disaster. This science-heavy thriller combines humor, heart, and hard science fiction in an irresistible package. Weir creates an unforgettable alien encounter that challenges everything Grace knows about intelligence and friendship. A thrilling adventure through space that celebrates scientific curiosity and the power of cooperation.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=600&fit=crop",
    genre: "Science Fiction",
    price: 18.99,
    rating: 4.8,
    reviewCount: 16742,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_017",
    title: "The Midnight Girls",
    author: "Alicia Jasinska",
    description:
        "Three girls living in a pocket of ancient wilderness discover they are the daughters of the witch Baba Yaga. When their powers awaken, they must choose between embracing their dark heritage or forging their own path. This atmospheric fantasy draws on Slavic folklore to create a haunting coming-of-age story. Jasinska weaves together themes of sisterhood, power, and the price of magic in a richly imagined world. A dark and beautiful tale that explores what it means to be a monster in a world that fears female power.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Young Adult Fantasy",
    price: 16.99,
    rating: 4.2,
    reviewCount: 4821,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_018",
    title: "Becoming",
    author: "Michelle Obama",
    description:
        "The former First Lady shares her deeply personal journey from the South Side of Chicago to the White House. Obama writes with grace and honesty about her experiences as a mother, wife, and advocate for change. This inspiring memoir offers insights into her childhood, career, and eight years in the White House. Her story demonstrates the power of hard work, education, and staying true to your values. A candid and inspiring account of one of the most influential women of our time.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "Biography/Memoir",
    price: 19.99,
    rating: 4.9,
    reviewCount: 45672,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_019",
    title: "The Guest List",
    author: "Lucy Foley",
    description:
        "On a remote island wedding venue, the celebration turns deadly when someone turns up dead. Told from multiple perspectives, this psychological thriller unravels the dark secrets of the wedding party. Foley masterfully builds suspense as she reveals each character's hidden motives and connections. The isolated setting creates a perfect storm for murder and mayhem. A gripping whodunit that will keep you guessing until the shocking conclusion.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    genre: "Mystery/Thriller",
    price: 16.49,
    rating: 4.5,
    reviewCount: 13956,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_020",
    title: "The House in the Cerulean Sea",
    author: "TJ Klune",
    description:
        "Linus Baker works for the Department in Charge of Magical Youth, inspecting magical children in government-sanctioned group homes. His latest assignment takes him to Marsyas Island, home to six dangerous magical children and their caretaker Arthur. This heartwarming fantasy celebrates found family, acceptance, and the courage to be yourself. Klune creates a whimsical world filled with hope, humor, and unconditional love. A joyful story that reminds us that family isn't always blood, and home is where you're accepted for who you are.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Fantasy Romance",
    price: 17.99,
    rating: 4.7,
    reviewCount: 22103,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_021",
    title: "Normal People",
    author: "Sally Rooney",
    description:
        "Following Connell and Marianne from their final year of school in Ireland to their undergraduate years at Trinity College Dublin, this novel explores their complex relationship. Despite their deep connection, they struggle with class differences, mental health, and miscommunication. Rooney's spare prose captures the intensity of young love and the pain of growing up. The story examines how power dynamics and social expectations can complicate even the deepest relationships. A raw and honest portrayal of modern love, friendship, and the journey to adulthood.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Contemporary Fiction",
    price: 16.99,
    rating: 4.3,
    reviewCount: 18745,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_022",
    title: "The Priory of the Orange Tree",
    author: "Samantha Shannon",
    description:
        "An epic standalone fantasy featuring dragons, political intrigue, and multiple heroines across different kingdoms. When an ancient enemy threatens to return, unlikely allies must unite to save their world from destruction. Shannon creates a richly detailed world with complex magic systems and diverse cultures. The novel features strong female characters, LGBTQ+ representation, and themes of friendship and sacrifice. A sweeping fantasy epic that proves standalone novels can be just as immersive as long series.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Epic Fantasy",
    price: 22.99,
    rating: 4.6,
    reviewCount: 11234,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_023",
    title: "Anxious People",
    author: "Fredrik Backman",
    description:
        "A failed bank robbery leads to a hostage situation at an apartment viewing, bringing together eight very different people. What starts as a crime story becomes a heartwarming exploration of human connection and the struggles we all face. Backman's signature humor and insight shine as he reveals each character's personal struggles and hopes. The novel explores themes of anxiety, parenthood, relationships, and forgiveness with both depth and levity. A touching reminder that we're all just anxious people trying to figure out life.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Contemporary Fiction",
    price: 17.49,
    rating: 4.4,
    reviewCount: 14637,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_024",
    title: "The Vanishing Half",
    author: "Brit Bennett",
    description:
        "Twin sisters choose to live on opposite sides of the color line in 1960s America, leading completely different lives. Years later, their daughters must grapple with the consequences of their mothers' choices. Bennett explores themes of identity, family, and the arbitrary nature of racial categories. The multi-generational saga spans decades and examines how the past shapes the present. A powerful exploration of race, identity, and the lengths people go to in order to reinvent themselves.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    genre: "Historical Fiction",
    price: 18.49,
    rating: 4.5,
    reviewCount: 20156,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_025",
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description:
        "Set in the summer of 1922, this American classic follows Nick Carraway as he becomes drawn into the world of his mysterious neighbor Jay Gatsby. Gatsby's obsessive pursuit of Daisy Buchanan serves as a critique of the American Dream. Fitzgerald's lyrical prose captures the excess and disillusionment of the Jazz Age. The novel explores themes of love, wealth, social class, and the corruption of the American Dream. A timeless masterpiece that continues to resonate with readers nearly a century after publication.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "Classic Literature",
    price: 12.99,
    rating: 4.4,
    reviewCount: 56789,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_026",
    title: "It Ends with Us",
    author: "Colleen Hoover",
    description:
        "Lily Bloom's life changes when she meets neurosurgeon Ryle Kincaid, but their relationship becomes complicated when her first love Atlas returns. This emotional contemporary romance tackles difficult topics including domestic violence and toxic relationships. Hoover writes with raw honesty about the complexity of abusive relationships and the courage it takes to break free. The novel explores themes of love, forgiveness, and finding the strength to choose yourself. A powerful story that has sparked important conversations about love and abuse.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-e4f6d10f5e5f?w=400&h=600&fit=crop",
    genre: "Contemporary Romance",
    price: 15.99,
    rating: 4.6,
    reviewCount: 38947,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_027",
    title: "The Atlas Six",
    author: "Olivie Blake",
    description:
        "Six young magicians are recruited to join the exclusive Alexandrian Society, but only five will be initiated. Set in an alternate world where magic is real, this dark academia fantasy explores power, ambition, and moral complexity. Each character possesses unique magical abilities and hidden agendas that create tension and intrigue. Blake crafts a sophisticated narrative that examines the price of knowledge and the corrupting influence of power. A cerebral and atmospheric fantasy that challenges readers with its morally gray characters and philosophical themes.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Dark Academia Fantasy",
    price: 19.99,
    rating: 4.2,
    reviewCount: 9876,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_028",
    title: "Sapiens: A Brief History of Humankind",
    author: "Yuval Noah Harari",
    description:
        "Harari traces the history of Homo sapiens from the Stone Age to the present, exploring how we became the dominant species on Earth. This fascinating blend of history, anthropology, and philosophy examines the major revolutions that shaped human civilization. From the cognitive revolution to the agricultural and scientific revolutions, Harari challenges conventional wisdom about human progress. The book raises profound questions about the future of humanity in an age of artificial intelligence and biotechnology. A thought-provoking exploration of what makes us human and where we're headed as a species.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "History/Anthropology",
    price: 18.99,
    rating: 4.7,
    reviewCount: 32154,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_029",
    title: "The Thursday Murder Club",
    author: "Richard Osman",
    description:
        "In a peaceful retirement village, four unlikely friends meet weekly to investigate cold cases, but they suddenly find themselves in the middle of their first live case. Elizabeth, Joyce, Ibrahim, and Ron use their years of experience and wisdom to solve mysteries that have baffled the police. A charming blend of humor, heart, and clever plotting that proves age is just a number. These septuagenarian sleuths will win your heart with their wit and determination. Perfect for fans of cozy mysteries with unforgettable characters.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Cozy Mystery",
    price: 15.49,
    rating: 4.6,
    reviewCount: 12890,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_030",
    title: "The Calculating Stars",
    author: "Mary Robinette Kowal",
    description:
        "In an alternate 1952, a meteorite strike threatens human civilization, launching an accelerated space program with women as pilots. Dr. Elma York fights against sexism and racism to become one of the first female astronauts. This alternate history science fiction combines hard science with social commentary about gender and race in the 1950s. Kowal creates a believable world where the space race begins a decade early out of necessity. A compelling story of perseverance, progress, and the fight for equality both on Earth and in space.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1446776877081-d282a0f896e2?w=400&h=600&fit=crop",
    genre: "Alternate History SF",
    price: 17.99,
    rating: 4.5,
    reviewCount: 7634,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_031",
    title: "Mexican Gothic",
    author: "Silvia Moreno-Garcia",
    description:
        "When socialite Noemí Taboada receives a disturbing letter from her newlywed cousin, she travels to the family's decaying English manor in rural Mexico. What she discovers there is a nightmare of secrets, madness, and supernatural horror. Moreno-Garcia masterfully blends Gothic horror with Mexican folklore and feminist themes. The atmospheric novel explores colonialism, racism, and the oppression of women through a supernatural lens. A chilling and beautiful horror story that updates Gothic conventions for modern readers.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Gothic Horror",
    price: 16.99,
    rating: 4.3,
    reviewCount: 15743,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
  Book(
    id: "book_032",
    title: "The Poppy War",
    author: "R.F. Kuang",
    description:
        "Rin, a war orphan, aces the entrance exam to Sinegard military academy and discovers she has a lethal power tied to the vengeful Phoenix god. This grimdark fantasy draws inspiration from 20th-century Chinese history, particularly the Second Sino-Japanese War. Kuang doesn't shy away from depicting the brutal realities of war and the moral complexity of revenge. The novel explores themes of power, trauma, and the cyclical nature of violence. A dark and unflinching examination of war that challenges readers with its unflinching portrayal of atrocity and survival.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Grimdark Fantasy",
    price: 18.49,
    rating: 4.4,
    reviewCount: 11267,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_033",
    title: "The Starless Sea",
    author: "Erin Morgenstern",
    description:
        "Graduate student Zachary finds a mysterious book that tells the story of his own childhood, leading him to a magical underground library. This enchanting fantasy weaves together multiple narratives across time and space in a celebration of stories and storytelling. Morgenstern creates a dreamlike world where reality and fiction blur together in beautiful, impossible ways. The novel is a love letter to books, libraries, and the power of narrative to transform our lives. A mesmerizing tale that will appeal to anyone who has ever been lost in a good book.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Literary Fantasy",
    price: 19.49,
    rating: 4.1,
    reviewCount: 8934,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_034",
    title: "Born a Crime",
    author: "Trevor Noah",
    description:
        "The Daily Show host shares stories from his childhood in South Africa during and after apartheid, when his very existence was illegal. Noah's memoir combines humor with heartbreaking insights into racism, poverty, and family relationships. His relationship with his remarkable mother forms the emotional core of this powerful book. The stories are both deeply personal and universally resonant, offering insights into resilience and the power of humor. A moving and funny memoir that illuminates a dark period in history through one man's extraordinary story.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "Biography/Memoir",
    price: 17.99,
    rating: 4.8,
    reviewCount: 29847,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_035",
    title: "The Power",
    author: "Naomi Alderman",
    description:
        "Women develop the ability to generate electrical shocks, fundamentally changing the balance of power between genders. This speculative fiction explores how society might change if women were physically dominant. Alderman examines themes of power, corruption, and gender roles through this thought-provoking premise. The novel challenges readers to think about power dynamics and whether changing who holds power really changes the nature of power itself. A provocative and timely exploration of gender, violence, and the corrupting influence of power.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-e4f6d10f5e5f?w=400&h=600&fit=crop",
    genre: "Speculative Fiction",
    price: 16.99,
    rating: 4.3,
    reviewCount: 16542,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_036",
    title: "Little Fires Everywhere",
    author: "Celeste Ng",
    description:
        "In 1990s suburban Shaker Heights, the arrival of artist Mia Warren and her daughter Pearl upends the Richardson family's perfectly ordered world. When a custody battle divides the community, long-buried secrets emerge and relationships are tested. Ng explores themes of privilege, motherhood, art, and the complexities of family relationships. The novel examines how the past shapes the present and the different ways people define family. A compelling drama about the weight of secrets and the power of art to reveal truth.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=600&fit=crop",
    genre: "Contemporary Fiction",
    price: 16.49,
    rating: 4.5,
    reviewCount: 24718,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_037",
    title: "The Final Empire",
    author: "Brandon Sanderson",
    description:
        "In a world where ash falls from the sky and mist dominates the night, the immortal Lord Ruler has reigned for a thousand years. Street thief Vin discovers she has magical powers and joins a crew planning the ultimate heist: overthrowing an empire. Sanderson creates one of fantasy's most innovative magic systems based on ingesting and burning metals. This epic fantasy combines heist elements with political intrigue and stunning magical battles. The first book in the acclaimed Mistborn series that revolutionized fantasy literature.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Epic Fantasy",
    price: 18.99,
    rating: 4.7,
    reviewCount: 35621,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_038",
    title: "Station Eleven",
    author: "Emily St. John Mandel",
    description:
        "A flu pandemic wipes out civilization, and twenty years later, a traveling theater troupe performs Shakespeare for scattered settlements. This post-apocalyptic novel focuses on art, memory, and human connection rather than violence and survival. Mandel weaves together multiple timelines to show how lives intersect before and after the collapse. The story celebrates the enduring power of art and culture to give meaning to human existence. A beautiful and hopeful vision of humanity's resilience in the face of catastrophe.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=600&fit=crop",
    genre: "Post-Apocalyptic Fiction",
    price: 17.49,
    rating: 4.4,
    reviewCount: 19365,
    isBestseller: false,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_039",
    title: "The Binding",
    author: "Bridget Collins",
    description:
        "In an alternate world, books are forbidden objects that steal memories from people's minds, and bookbinders are feared and reviled. When Emmett becomes apprentice to a bookbinder, he discovers the dark secrets behind this mysterious craft. Collins creates a unique magic system where traumatic memories can be extracted and bound into books. The novel explores themes of memory, identity, love, and the power of stories to both heal and harm. A haunting fantasy that examines what we choose to remember and what we prefer to forget.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=600&fit=crop",
    genre: "Historical Fantasy",
    price: 18.49,
    rating: 4.2,
    reviewCount: 12743,
    isBestseller: false,
    isNewArrival: true,
    createdAt: DateTime.now(),
  ),

  Book(
    id: "book_040",
    title: "Untamed",
    author: "Glennon Doyle",
    description:
        "Activist and author Glennon Doyle shares her journey from living according to others' expectations to embracing her authentic self. This memoir explores marriage, motherhood, sexuality, and faith with raw honesty and vulnerability. Doyle challenges readers to question societal expectations and live according to their own truth. The book became a phenomenon for its empowering message about breaking free from conditioning and choosing authenticity. An inspiring call to action for anyone who has ever felt caged by others' expectations.",
    coverImageUrl:
        "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=600&fit=crop",
    genre: "Self-Help/Memoir",
    price: 17.99,
    rating: 4.6,
    reviewCount: 27834,
    isBestseller: true,
    isNewArrival: false,
    createdAt: DateTime.now(),
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  for (var book in seedBooksList) {
    await firestore.collection('books').doc(book.id).set(book.toMap());
    print("📚 Added: ${book.title}");
  }

  print("✅ Seeded ${seedBooksList.length} books successfully!");
}
