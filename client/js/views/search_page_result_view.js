/**
 * @fileOverview This file has functions related to search page result view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Search Page Result View
 * @class SearchPageResultView
 * @constructor
 * @extends Backbone.View
 */
App.SearchPageResultView = Backbone.View.extend({
    template: JST['templates/search_page_result'],
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    events: {
        'click .js-open-search-model-card-view': 'showSearchModalCardView',
        'click .js-load-more-search': 'loadMoreSearch'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            search_result: this.model.result
        }));
        this.showTooltip();
        return this;
    },
    showSearchModalCardView: function(e) {
        var self = this;
        var cards = new App.Card();
        var board_id = $(e.currentTarget).data('board_id');
        var list_id = $(e.currentTarget).data('list_id');
        var card_id = $(e.currentTarget).data('card_id');
        var board = new App.Board({
            id: board_id
        });
        board.url = api_url + 'boards/' + board_id + '.json';
        board.id = board_id;
        board.fetch({
            cache: false,
            abortPending: true,
            success: function(model, response) {
                var acl_links = board.get('acl_links') || [];
                board.acl_links.reset(acl_links, {
                    silent: true
                });
                var lists = board.get('lists') || [];
                board.lists.reset(lists, {
                    silent: true
                });
                var activities = board.get('activities') || [];
                board.activities.reset(activities, {
                    silent: true
                });
                var board_users = board.get('boards_users') || [];
                board.board_users.reset(board_users, {
                    silent: true
                });
                var custom_attachments = board.get('custom_backgrounds') || [];
                board.custom_attachments.reset(custom_attachments, {
                    silent: true
                });
                var attachments = board.get('attachments') || [];
                board.attachments.reset(attachments, {
                    silent: true
                });
                var boards_subscribers = board.get('boards_subscribers') || [];
                board.board_subscribers.add(boards_subscribers, {
                    silent: true
                });
                var boards_stars = board.get('boards_stars') || [];
                board.board_stars.add(boards_stars, {
                    silent: true
                });
                board.lists.each(function(list) {
                    var cards = list.get('cards') || [];
                    if (!_.isEmpty(cards)) {
                        board.cards.add(cards, {
                            silent: true
                        });
                    }
                });
                board.cards.each(function(card) {
                    var checklists = card.get('cards_checklists') || [];
                    if (!_.isEmpty(checklists)) {
                        board.checklists.add(checklists, {
                            silent: true
                        });
                        if (!_.isEmpty(board.checklists)) {
                            board.checklists.each(function(checklist) {
                                var checklist_itmes = checklist.get('checklists_items') || [];
                                if (!_.isEmpty(checklist_itmes)) {
                                    board.checklist_items.add(checklist_itmes, {
                                        silent: true
                                    });
                                }
                            });
                        }
                    }
                    var labels = card.get('cards_labels') || [];
                    if (!_.isEmpty(labels)) {
                        board.labels.add(labels, {
                            silent: true
                        });
                    }
                });

                board.lists.each(function(list) {
                    if (list.id === list_id) {
                        list.board_users = board.board_users;
                        list.labels = board.labels;
                        list.activities.add(board.activities, {
                            silent: true
                        });
                        list.attachments = board.attachments;
                        list.board_user_role_id = board.board_user_role_id;
                        list.board = board;
                        list.activities.add(board.activities, {
                            silent: true
                        });
                        var filtered_cards = list.collection.board.cards.where({
                            list_id: list.id
                        });
                        var cards = new App.CardCollection();
                        cards.reset(filtered_cards);
                        list.cards.add(cards.toJSON(), {
                            silent: true
                        });
                        list.cards.each(function(card) {
                            if (card.id === card_id) {
                                if (parseInt(card.get('is_archived')) === 0) {
                                    card.board_users = list.board_users;
                                    var filter_labels = list.labels.filter(function(model) {
                                        return parseInt(model.get('card_id')) === parseInt(card_id);
                                    });
                                    var labels = new App.CardLabelCollection();
                                    labels.add(filter_labels, {
                                        silent: true
                                    });
                                    card.labels = labels;
                                    card.card_voters.add(card.get('cards_voters'), {
                                        silent: true
                                    });
                                    card.cards_subscribers.add(card.get('cards_subscribers'), {
                                        silent: true
                                    });
                                    card.checklists.add(card.get('cards_checklists'), {
                                        silent: true
                                    });
                                    card.cards = list.collection.board.cards;
                                    card.list = list;
                                    card.board_activities.add(list.activities, {
                                        silent: true
                                    });
                                    filter_attachments = list.attachments.where({
                                        card_id: card.id
                                    });
                                    card.attachments.add(filter_attachments, {
                                        silent: true
                                    });
                                    card.board = list.board;

                                    var users = card.get('cards_users') || [];
                                    if (!_.isEmpty(users)) {
                                        card.users.add(users, {
                                            silent: true
                                        });
                                    }

                                    var initialState = (DEFAULT_CARD_VIEW === 'Normal Dockmodal') ? 'docked' : 'modal';
                                    if (e.ctrlKey || e.metaKey) {
                                        initialState = 'modal';
                                    }
                                    var modalView = new App.ModalCardView({
                                        model: card,
                                        initialState: initialState
                                    });
                                    var view_card = this.$('#js-card-listing-' + card.id);
                                    view_card.html('&nbsp;');
                                    modalView.show();
                                    return false;
                                }
                            }
                        });
                    }
                });
            }
        });
    },
    loadMoreSearch: function(e) {
        var q = $(e.currentTarget).data('search');
        var page = parseInt($(e.currentTarget).data('page'));
        var data_for = $(e.currentTarget).data('for');
        var elastic_search = new App.ElasticSearchCollection();
        elastic_search.url = api_url + 'search.json';
        elastic_search.fetch({
            data: {
                q: q,
                page: page,
                data_for: data_for,
                token: api_token
            },
            success: function(model, response) {
                response = response;
                response.result.search_term = q;
                app.navigate('#/search/' + data_for + ':' + q, {
                    trigger: false,
                    trigger_function: false,
                    replace: true
                });
                $('#search-page-result-block').html(new App.SearchPageResultView({
                    model: response
                }).el);
                $("#search-page-result").removeClass("search-block").addClass("search-block-main-hover");
                var w_height = $(window).height() - 38;
                $(".search-block-main-hover").css('height', w_height + 'px');
            }
        });
        return false;
    }
});
