<script>

export default {
  data() {
    return {
      book: {},
      view: false,
      arrangement: 'VerticalInfinite',
      currentPage: 0,
    }
  },
  mounted() {
    let self = this;
    window.addEventListener('message', this.onMessage);
    window.addEventListener('keyup', function (e) {
      if (e.key == "Escape") {
        self.fireEvent('closeAll')
      }
    });
  },
  destroyed() {
    window.removeEventListener('message')
    window.removeEventListener('keyup')
  },
  methods: {
    onMessage(event) {
      if (event.data.type === 'view') {
        this.book = event.data.book
        this.arrangement = 'VerticalInfinite'
        this.view = true
        this.currentPage = 0
      }
      if (event.data.type === 'viewPublished') {
        this.book = event.data.book
        this.arrangement = event.data.book.arrangement
        this.book.active = true
        this.book.title = event.data.title
        this.view = true
        this.currentPage = 0
      }
      if (event.data.type === 'close') {
        this.view = false
      }

    },
    fireEvent(eve, opts = {}) {
      fetch(`https://${GetParentResourceName()}/` + eve, {
        method: 'POST',
        body: JSON.stringify(opts)
      })
    },
    // getImageUrl(name) {
    //   return new URL(`/${name}.png`, import.meta.url).href
    // }
    // getImageUrl(name) {
    //   return new URL(`../assets/${name}`, import.meta.url).href
    // },
    toggleAltText(pageIndex) {
      if (this.book.pages[pageIndex].isAlt){
        this.book.pages[pageIndex].isAlt = null
      }else{
        this.book.pages[pageIndex].isAlt = true
      }
    },
    prevPage(numOfPages){
      this.currentPage -= numOfPages
    },
    nextPage(numOfPages){
      this.currentPage += numOfPages
    },
  },
};

</script>

<template>
  <header>
  </header>

  <main>

    <!-- VIEW BOOK -->

    <div class="wrapper ma-5" v-if="view && book.active">
      <div class="view-book-box">

        <div class="float-right mr-7 mt-2">
          <v-btn variant="text" @click="fireEvent('closeView')">x</v-btn>
        </div>

        <v-container class="ma-5 w-auto pl-10 pr-11 py-3">
          <v-row>
            <v-col align-self="center">
              <div class="mx-5">
                <h1 class="font-rdr text-center ml-5 mr-5">{{book.label || book.title}}</h1>
              </div>
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <hr />
            </v-col>
          </v-row>
          <v-row>
            <v-col>

              <div v-if="this.arrangement=='VerticalInfinite'">
                <div class="book-container-vertical-infinite">
                  <div class="book-img-container mb-3" v-for="(page, index) in book.pages" :id="'page_'+index" @click="toggleAltText(index)">

                    <v-fade-transition>
                      <img :src="page.img || page.url" :alt="page.alt || page.altText" class="book-img" v-show="!page.isAlt" />
                    </v-fade-transition>

                    <v-fade-transition>
                      <v-card variant="outlined" class="book-page-alt" v-show="page.isAlt">
                        <v-card-text>
                          <span v-html="page.alt || page.altText"></span>
                        </v-card-text>
                      </v-card>
                    </v-fade-transition>

                  </div>
                </div>
              </div>

              <div v-if="this.arrangement=='HorizontalOnePage'">
                <div class="book-container-horizontal-one-page">

                  <v-carousel show-arrows="hover" hide-delimiters height="800" :continuous="false">
                    <v-carousel-item
                      v-for="(page, index) in book.pages"
                      :id="'page_'+index"
                      @click="toggleAltText(index)"
                      :src="page.img || page.url" :alt="page.alt || page.altText"
                    ></v-carousel-item>
                  </v-carousel>

                </div>
              </div>

              <div v-if="this.arrangement=='HorizontalTwoPage'">
                <div class="book-container-horizontal-two-page">

                  <div>
                    <v-btn icon="mdi-chevron-left-circle" @click="prevPage(2)" :style="{visibility: this.currentPage>0 ? 'visible' : 'hidden'}"></v-btn>
                  </div>
                  <div>
                    <img :src="book.pages[this.currentPage].img || book.pages[this.currentPage].url" :alt="book.pages[this.currentPage].alt || book.pages[this.currentPage].altText" class="book-img" v-show="!book.pages[this.currentPage].isAlt" />
                  </div>
                  <div>
                    <img :src="book.pages[this.currentPage+1].img || book.pages[this.currentPage+1].url" :alt="book.pages[this.currentPage+1].alt || book.pages[this.currentPage+1].altText" class="book-img" v-show="!book.pages[this.currentPage+1].isAlt" />
                  </div>
                  <div>
                    <v-btn icon="mdi-chevron-right-circle" @click="nextPage(2)" :style="{visibility: (this.currentPage+1)<(this.book.pages.length-1) ? 'visible' : 'hidden'}"></v-btn>
                  </div>

                </div>
              </div>



            </v-col>
          </v-row>

        </v-container>
      </div>
    </div>

  </main>
</template>

<style scoped>
  .v-card-text {
    font-size: 1.5rem !important;
    line-height: 2rem !important;
  }
</style>
