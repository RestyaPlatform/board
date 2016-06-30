/**
 * @fileOverview This file has functions related to organization view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: organizations model.
 */
if (typeof App === 'undefined') {
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
        this.populateAclLinks();
        if (!_.isUndefined(authuser.user)) {
            var organization_user_role_id = this.model.organizations_users.findWhere({
                user_id: parseInt(authuser.user.id)
            });
            if (!_.isEmpty(organization_user_role_id)) {
                this.model.organization_user_role_id = organization_user_role_id.attributes.organization_user_role_id;
            }
        }
        this.render();
        if (this.type === 'users') {
            this.getOrganizationMemberLists();
        }
        this.model.boards.bind('change:organization_id remove', this.renderOrganizationCollection, this);


    },
    // Resets this boards acl_links collection
    populateAclLinks: function() {
        var acl_links = this.model.get('acl_links') || [];
        this.model.acl_links.reset(acl_links, {
            silent: true
        });
    },
    template: JST['templates/organization_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
        'click .js-get-organization-member-lists': 'getOrganizationMemberLists',
        'click .js-edit-organization-member-permission': 'editOrganizationMemberPermission',
        'click .js-trigger-logo-upload': 'triggerLogoUpload',
        'change .js-edit-organization-logo': 'editOrganizationLogo',
        'click .js-show-confirm-delete-organization-member': 'showConfirmDeleteOrganizationMember',
        'click .js-show-confirm-delete-organization-current-member': 'showConfirmDeleteOrganizationCurrentMember',
        'click .js-user-board-list': 'userBoardList',
        'click .js-remove-image': 'removeImage',
        'click .js-all-user-activities': 'showUserActivities',
        'click .js-org-image-uploaded': 'computerOpenOrg',
        'change #js-org-attachment': 'addOrganizationImage',
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
                if (response.error === 1) {
                    self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                } else {
                    model.set('logo_url', response.logo_url);
                    self.render();
                    if (self.type === 'users') {
                        self.getOrganizationMemberLists();
                    }
                    $('#js-organization-logo-9').attr('href', response.logo_url);
                }
            }
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
     * editOrganizationMemberPermission()
     * change organization member permission
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    editOrganizationMemberPermission: function(e) {
        var self = this;
        var target = $(e.currentTarget);
        var organizations_user_id = target.data('organizations_user_id');
        var organizations_id = target.data('organizations_id');
        //$('.js-change-permission-content-' + organizations_user_id).html('Normal');
        target.parents('li.dropdown').removeClass('open');
        var organizationsUser = new App.OrganizationsUser();
        organizationsUser.url = api_url + 'organizations_users/' + organizations_user_id + '.json';
        organizationsUser.set('id', organizations_user_id);
        organizationsUser.set('organization_id', organizations_id);
        organizationsUser.set('organization_user_role_id', target.data('organization_user_role_id'));
        this.model.organizations_users.get(parseInt(organizations_user_id)).set('organization_user_role_id', target.data('organization_user_role_id'));
        self.getOrganizationMemberLists();
        organizationsUser.save({
            organization_user_role_id: target.data('organization_user_role_id')
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
        $('#header').html(new App.OrganizationHeaderView({
            model: this.model,
            type: self.page_view_type
        }).el);
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
                acceptFileTypes: /(\.|\/)(jpe?g|png|bmp|gif)$/i,
            });
            uploadManager.on('fileadd', function(file) {
                $('#org-loader').addClass('cssloader');
                var allowedExt = /(\.jpg|\.jpeg|\.bmp|\.gif|\.png)$/i;
                if (!allowedExt.exec(file.attributes.data.name)) {
                    _this.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                    $('#org-loader').removeClass('cssloader');
                }
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
     * computerOpenOrg()
     * trigger file upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    computerOpenOrg: function(e) {
        e.preventDefault();
        var fileLi = $(e.target);
        $('#js-user-profile-attachment').remove();
        var form = $('#js-org-drag');
        $(form).append('<input class="hide" type="file" name="attachment" id="js-org-attachment">');
        $('#js-org-attachment', form).trigger('click');
        return false;
    },
    /**
     * computerOpenUserProfile()
     * trigger file upload
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    addOrganizationImage: function(e) {
        e.preventDefault();
        $('#org-loader').addClass('cssloader');
        var self = this;
        var form = $(e.target);
        //var fileData = new FormData(form[0]);
        var formData = new FormData();
        formData.append('file', $('input[type=file]')[0].files[0]);
        //var data = $(e.target).serializeObject();
        //this.model.set(data);
        this.render();
        this.model.url = api_url + 'organizations/' + this.model.organization_id + '/upload_logo.json';
        this.model.save(formData, {
            patch: true,
            type: 'POST',
            data: formData,
            processData: false,
            cache: false,
            contentType: false,
            error: function(e, s) {
                self.flash('danger', i18next.t('Unable to update. Please try again.'));
            },
            success: function(model, response) {
                $('#org-loader').removeClass('cssloader');
                if (!_.isUndefined(response.logo_url)) {
                    self.model.set('logo_url', response.logo_url);
                    self.render();
                    if (self.type === 'users') {
                        self.getOrganizationMemberLists();
                    }
                } else {
                    self.flash('danger', i18next.t('File extension not supported. It supports only jpg, png, bmp and gif.'));
                }
            }
        });
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
                if (board.attributes.is_closed === 0) {
                    board.board_stars.add(board.attributes.boards_stars);
                    self.model.board_users.add(board.attributes.boards_users);
                    var stared;
                    if (!_.isUndefined(authuser.user)) {
                        stared = board.board_stars.findWhere({
                            is_starred: 1
                        });
                    }
                    var view = new App.OrganizationBoardView({
                        model: board,
                        stared: stared
                    });
                    view_board.append(view.el);
                }
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
