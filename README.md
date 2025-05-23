# pika_dex

A new Flutter project that integrates the "Poke API" to get the data of all the pokemon's.
This App also focuses on user experience and there preferences of pokemons with a favorite section.

All the pokemon's data will be fetched and displayed using dio and get_it.
State managanement tool used: Riverpod.
LocalStorage tool used: Shared Prefereneces.
For user experience and no boredom of data fetch the app's widget are integrated with skeletonizer.
For fonts GoogleFonts package is user.

Concepts used:

- Pagination: Loading/Fetching the data in chunks. Which serves less burden on the App and the server.
- Riverpod state caching.
- Riverpod stateNotifier Provider used to change and centralize the immumatable state. Which means a state will listen to the provider when it wants itself to change. This will be integrated with paginaion.
-
