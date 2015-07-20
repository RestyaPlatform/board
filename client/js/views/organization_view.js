/**
 * @fileOverview This file has functions related to organization view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations model.
 */
if (typeof App == 'undefined') {
    App = {};
}
/**
 * Organizations View
 * @class OrganizationsView
 * @constructor
 * @extends Backbone.View
 */
App.OrganizationsView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.type = options.type;
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.model.organizations_users.add(this.model.attributes.organizations_users);
        this.render();
        if (this.type === 'users') {
            this.getOrganizationMemberLists();
        }
        this.model.boards.bind('change:organization_id remove', this.renderOrganizationCollection, this);

    },
    template: JST['templates/organization_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {

        'click .js-close-popover': 'closePopup',
        'click .js-get-organization-member-lists': 'getOrganizationMemberLists',
        'click .js-edit-organization-member-permission-to-admin': 'editOrganizationMemberPermissionToAdmin',
        'click .js-edit-organization-member-permission-to-normal': 'editOrganizationMemberPermissionToNormal',
        'click .js-trigger-logo-upload': 'triggerLogoUpload',
        'change .js-edit-organization-logo': 'editOrganizationLogo',
        'click .js-show-confirm-delete-organization-member': 'showConfirmDeleteOrganizationMember',
        'click .js-show-confirm-delete-organization-current-member': 'showConfirmDeleteOrganizationCurrentMember',
        'click .js-user-board-list': 'userBoardList',
        'click .js-remove-image': 'removeImage',
        'click .js-all-user-activities': 'showUserActivities',
    },
    /**
     * editOrganizationLogo()
     * update organization logo
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationLogo: function(ev) {
        var self = this;
        var form = $('form.attachment-form-logo');
        var fileData = $('form.attachment-form-logo').serializeObject();
        var organization = new App.Organization();
        organization.url = api_url + 'organizations/' + self.model.organization_id + '/upload_logo.json';
        organization.save({}, {
            data: {},
            files: $('input.js-edit-organization-logo', form),
            iframe: true
        }, {
            success: function(model, response) {
                model.set('logo_url', response.logo_url);
                self.render();
                if (self.type === 'users') {
                    self.getOrganizationMemberLists();
                }
                $('#js-organization-logo-9').attr('href', response.logo_url);
            },
            error: function(model, response) {}
        });
        return false;
    },
    /**
     * triggerLogoUpload()
     * trigger organization logo upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    triggerLogoUpload: function(e) {
        $('.js-edit-organization-logo').trigger('click');
        return false;
    },
    /**
     * showConfirmDeleteOrganizationMember()
     * display organization delete confirmation
     * @param e
     * @type Object(DOM event)
     */
    showConfirmDeleteOrganizationMember: function(e) {
        var target = $(e.currentTarget);
        var parent = target.parents('.js-show-confirm-delete-organization-member-dropdown');
        var insert = $('.js-show-confirm-delete-organization-member-response', parent);
        insert.nextAll().remove();
        var organizations_user_id = target.data('organizations_user_id');
        this.model.organizations_user_id = organizations_user_id;
        $(new App.OrganizationMemberRemoveFormView({
            model: this.model
        }).el).insertAfter(insert);
    },
    /**
     * showConfirmDeleteOrganizationCurrentMember()
     * display organization member remove confirmation
     * @param e
     * @type Object(DOM event)
     */
    showConfirmDeleteOrganizationCurrentMember: function(ev) {
        var target = $(ev.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        this.model.organizations_user_id = organizations_user_id;
        $('.js-show-confirm-delete-organization-member-response').html(new App.OrganizationMemberConfirmRemoveFormView({
            model: this.model
        }).el);
    },
    /**
     * editOrganizationMemberPermissionToNormal()
     * change organization member permission to normal
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationMemberPermissionToNormal: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        $('.js-change-permission-content-' + organizations_user_id).html('Normal');
        target.parents('li.dropdown').removeClass('open');
        var organizationsUser = new App.OrganizationsUser();
        organizationsUser.url = api_url + 'organizations_users/' + organizations_user_id + '.json';
        organizationsUser.set('id', organizations_user_id);
        organizationsUser.set('is_admin', false);
        this.model.organizations_users.get(parseInt(organizations_user_id)).set('is_admin', false);
        self.getOrganizationMemberLists();
        organizationsUser.save({
            is_admin: false
        });
        return false;
    },
    /**
     * editOrganizationMemberPermissionToAdmin()
     * change organization member permission to admin
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationMemberPermissionToAdmin: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        $('.js-change-permission-content-' + organizations_user_id).html('Admin');
        target.parents('li.dropdown').removeClass('open');
        var organizationsUser = new App.OrganizationsUser();
        organizationsUser.url = api_url + 'organizations_users/' + organizations_user_id + '.json';
        organizationsUser.set('id', organizations_user_id);
        organizationsUser.set('is_admin', true);
        this.model.organizations_users.get(parseInt(organizations_user_id)).set('is_admin', true);
        self.getOrganizationMemberLists();
        organizationsUser.save({
            is_admin: true
        });

        return false;
    },

    /**
     * getOrganizationMemberLists()
     * display organization members list
     */
    getOrganizationMemberLists: function() {
        var organizationsUserView = new App.OrganizationsUserView({
            model: this.model,
        });
        this.$('#member').html(organizationsUserView.el);
        this.$('#member').find('[data-toggle="tooltip"]').tooltip();
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
            organization: this.model,
            type: this.type
        }));
        this.renderOrganizationCollection();

        var _this = this;
        _(function() {
            Backbone.TemplateManager.baseUrl = '{name}';
            var uploadManager = new Backbone.UploadManager({
                uploadUrl: api_url + 'organizations/' + _this.model.organization_id + '/upload_logo.json?token=' + api_token,
                autoUpload: true,
                dropZone: $('#dropzone'),
                singleFileUploads: true,
                formData: $('form.js-user-profile-edit').serialize(),
                fileUploadHTML: '<input id="fileupload1" type="file" name="attachment"  >',
                maxNumberOfFiles: 1,
                acceptFileTypes: /(\.|\/)(jpe?g|png)$/i,
            });
            uploadManager.on('fileadd', function(file) {
                $('#org-loader').addClass('cssloader');
            });
            uploadManager.on('fileuploaddragover', function(e) {
                $('#js-org-drag').addClass('drophover');
            });
            var dragging = 0;
            $('#dropzone').on('dragenter', function(e) {
                dragging++;
                $('#js-org-drag').addClass('drophover');
            });
            $('#dropzone').on('dragleave', function(e) {
                dragging--;
                if (dragging === 0 || !$.browser.chrome) {
                    $('#js-org-drag').removeClass('drophover');
                }
            });
            uploadManager.on('fileuploaddrop', function(e) {
                dragging--;
                $('#js-org-drag').removeClass('drophover');
            });
            uploadManager.on('filedone', function(file, data) {
                $('#org-loader').removeClass('cssloader');
                if (!_.isUndefined(data.result.logo_url)) {
                    _this.model.set('logo_url', data.result.logo_url);
                    _this.render();
                    if (_this.type === 'users') {
                        _this.getOrganizationMemberLists();
                    }
                }
            });
            uploadManager.renderTo($('#manager-area'));
        }).defer();
        this.showTooltip();
        return this;
    },
    /**
     * renderOrganizationCollection()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    renderOrganizationCollection: function() {
        var self = this;
        var view_board = this.$el.find('#js-organization-board-listing');
        view_board.html('');
        if (!_.isEmpty(this.model.boards.models)) {
            this.model.boards.each(function(board) {
                board.board_stars.add(board.attributes.boards_stars);
                self.model.board_users.add(board.attributes.boards_users);
                var stared;
                if (!_.isUndefined(authuser.user)) {
                    stared = board.board_stars.findWhere({
                        user_id: parseInt(authuser.user.id)
                    });
                }
                var view = new App.OrganizationBoardView({
                    model: board,
                    stared: stared
                });
                view_board.append(view.el);
            });
        } else {
            var view = new App.OrganizationBoardView({
                model: null,
                stared: null,
                className: 'alert alert-info',
            });
            view_board.append(view.render().el);
        }
    },
    /**
     * editOrganization()
     * hide opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        target.parents('div.btn-group').removeClass('open');
        return false;
    },
    /**
     * userBoardList()
     * display organizationboard list
     * @param e
     * @type Object(DOM event)
     */
    userBoardList: function(e) {
        e.preventDefault();
        var user_id = $(e.currentTarget).data('user-id');
        var user_name = $(e.currentTarget).data('user-name');
        var user_boards = this.model.board_users.where({
            user_id: parseInt(user_id)
        });
        var board_users = new App.BoardsUserCollection();
        board_users.add(user_boards);
        board_users.username = user_name;
        $(e.currentTarget).parents('.js-user-board-list-response').html(new App.UserBoardslistingMenuView({
            model: board_users
        }).el);
        return false;
    },
    showUserActivities: function(e) {
        e.preventDefault();
        var user_id = $(e.target).data('user_id');
        var modalView = new App.ModalActivityView({
            model: user_id,
            organization_id: this.model.id,
            type: 'org_user_listing'
        });
        modalView.show();
        return false;
    },
    /**
     * removeImage()
     * remive image
     * @param e
     * @type Object(DOM event)
     */
    removeImage: function(e) {
        e.preventDefault();
        this.model.set('logo_url', null);
        this.render();
        if (this.type === 'users') {
            this.getOrganizationMemberLists();
        }
        this.model.url = api_url + 'organizations/' + this.model.id + '.json';
        this.model.save({
            logo_url: 'NULL'
        }, {
            patch: true
        });
        return false;
    }
});
