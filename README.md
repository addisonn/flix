# Project 2 - *Name of App Here*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **18** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.

The following **additional** features are implemented:

- In the detail view, when the user taps the poster, a new screen is presented modally where they can view the trailer
- User can tap a poster in the collection view to see a detail screen of that movie
- Using a third party loader rather than the standard iOS loader
- Make the whole now playing page fade in

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Loading more movies than just the first page and loading them incrementally (rather than getting them all in one API call) - could this lead to infinite content? 
2. More things with gestures - dragging, long tapping, etc. - when do we need to do them manually v. drag and drop?

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/ubNiuoCQSZ.gif' width='' alt='Video Walkthrough' />

GIF created with [RecordIt](http://recordit.co/).

## Notes

Describe any challenges encountered while building the app.
One thing that was challenging was implementing the trailer feature, specifically associating a gesture to a specific element (the poster view), as it could only be done programmatically and not thro the normal associative drag and dropping. The search bar was also a bit confusing as the predicate takes a bit to figure out which exact object/element referenced. 

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
-[MBProgressHUD](https://github.com/matej/MBProgressHUD) - iOS drop-in loader class

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
